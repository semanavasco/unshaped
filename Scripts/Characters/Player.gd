extends Area2D


export(int) var SPEED = 200
export(int) var HEALTH = 3
export(int) var MAX_HEALTH = 3
export(int) var DAMAGE = 1
export(int) var DASH_TIME_BONUS = 10
export(float) var DASH_TIME_LEFT = 0
export(float) var SHOOT_SPEED = 0.5
export(bool) var CAN_SHOOT = true
export(bool) var CAN_DASH = true
export(bool) var CAN_HURT = true
export(String) var BOOSTS = "None"


const SquareProjectile = preload("res://Scenes/Projectiles/SquareProjectile.tscn")
const TriangleProjectile = preload("res://Scenes/Projectiles/TriangleProjectile.tscn")
const ScoreIndicator = preload("res://Scenes/UI/ScoreIndicator.tscn")
const DamageParticles = preload("res://Scenes/Particles/WhiteDamage.tscn")
const PlayerDash = preload("res://Scenes/Particles/PlayerDash.tscn")
const ScreenHit = preload("res://Scenes/UI/ScreenHit.tscn")
const DeathMenu = preload("res://Scenes/UI/DeathMenu.tscn")


onready var Game = get_node("/root/Game")
onready var DashTimerUI = get_parent().get_node("DashTimer")
onready var DashTimeBar = get_parent().get_node("DashTimer/DashTimeBar")


var ScreenSize
var AttackTimer
var DashTimer
var PreviousSpeed


func _ready():
	ScreenSize = get_viewport_rect().size
	
	DashTimer = Timer.new()
	add_child(DashTimer)
	
	DashTimer.connect("timeout", self, "_on_DashTimer_timeout")
	DashTimer.set_wait_time(0.05)
	DashTimer.set_one_shot(false)
	DashTimer.start()


func _on_DashTimer_timeout():
	if BOOSTS != "Dash":
		DashTimerUI.visible = false
		return
	if DASH_TIME_LEFT <= 0:
		DASH_TIME_LEFT = 0
		BOOSTS = "None"
		DashTimerUI.visible = false
		return
	
	if DashTimerUI.visible == false:
		DashTimerUI.visible = true
	
	DASH_TIME_LEFT -= 0.05
	DashTimeBar.value = DASH_TIME_LEFT


func _on_Timer_timeout():
	CAN_SHOOT = true
	AttackTimer.queue_free()


func _physics_process(delta):
	if CAN_SHOOT == false:
		$Cursor.visible = false
	else:
		$Cursor.visible = true
	
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_just_pressed("switch"):
		switch()
	if Input.is_action_just_pressed("shoot"):
		if CAN_SHOOT == true:
			CAN_SHOOT = false
			shoot($Cursor.animation)
	if Input.is_action_just_pressed("dash") and BOOSTS == "Dash":
		dash()
	
	if velocity.length() > 0:
		velocity = velocity.normalized()
		$AnimatedSprite.animation = "Walk"
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.animation = "Idle"
		$AnimatedSprite.stop()
	
	position += velocity * delta * SPEED
	position.x = clamp(position.x, 0, ScreenSize.x)
	position.y = clamp(position.y, 0, ScreenSize.y)
	
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0
	
	$Cursor.look_at(get_global_mouse_position())


func switch():
	if $Cursor.animation == "Square":
		$Cursor.animation = "Triangle"
	else: $Cursor.animation = "Square"


func shoot(shape):
	var ProjectileInstance
	var ProjectileRotation = $Cursor.rotation_degrees
	var ProjectilePosition = $Cursor/Position2D.global_position
	
	if shape == "Square":
		ProjectileInstance = SquareProjectile.instance()
	else: ProjectileInstance = TriangleProjectile.instance()
	
	ProjectileInstance.rotation_degrees = ProjectileRotation
	ProjectileInstance.position = ProjectilePosition
	
	get_parent().add_child(ProjectileInstance)
	
	ProjectileInstance.velocity = get_global_mouse_position() - global_position
	
	create_AttackTimer()


func _on_Player_body_entered(body):
	if "SquareEnemyHitBox" in body.get_name() or "TriangleEnemyHitBox" in body.get_name() or "LozengeEnemyHitBox" in body.get_name():
		if not CAN_HURT:
			return
		HEALTH -= 1
		Game.SCORE -= 50
		spawnScoreIndicator("-50")
		
		var DamageEffect = DamageParticles.instance()
		DamageEffect.global_position = global_position
		get_parent().add_child(DamageEffect)
	
		createScreenHitEffect(body)
		
		if HEALTH <= 0:
			game_over()


func game_over() -> void:
	get_parent().get_node("Life/HpBar").value = 0
	get_parent().get_node("Life/Label").text = "0"
	
	if Game.SCORE > GameSettings.HIGH_SCORE:
		GameSettings.HIGH_SCORE = Game.SCORE
	
	GameSettings.LAST_SCORE = Game.SCORE
	
	GameSettings.saveData()
	
	var DeathMenuInstance = DeathMenu.instance()
	get_parent().add_child(DeathMenuInstance)


func spawnScoreIndicator(score) -> void:
	var effect = ScoreIndicator.instance()
	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position
	
	effect.label.text = String(score)


func create_AttackTimer() -> void:
	AttackTimer = Timer.new()
	add_child(AttackTimer)
	
	AttackTimer.connect("timeout", self, "_on_Timer_timeout")
	AttackTimer.set_wait_time(SHOOT_SPEED)
	AttackTimer.set_one_shot(true)
	AttackTimer.start()


func createScreenHitEffect(enemy) -> void:
	if "TriangleEnemyHitBox" in enemy.get_name():
		var ScreenHitEffect = ScreenHit.instance()
		ScreenHitEffect.animation = "Blue"
		get_parent().add_child(ScreenHitEffect)
		ScreenHitEffect.global_position = Vector2(575.5, 323)
	elif "LozengeEnemyHitBox" in enemy.get_name():
		var ScreenHitEffect = ScreenHit.instance()
		ScreenHitEffect.animation = "Orange"
		get_parent().add_child(ScreenHitEffect)
		ScreenHitEffect.position = Vector2(575.5, 323)
	elif "SquareEnemyHitBox" in enemy.get_name():
		var ScreenHitEffect = ScreenHit.instance()
		ScreenHitEffect.animation = "Red"
		get_parent().add_child(ScreenHitEffect)
		ScreenHitEffect.position = Vector2(575.5, 323)


func dash():
	if not CAN_DASH:
		return
	CAN_DASH = false
	CAN_HURT = false
	PreviousSpeed = SPEED
	SPEED *= 3
	
	var PlayerDashEffect = PlayerDash.instance()
	add_child(PlayerDashEffect)
	PlayerDashEffect.global_position = global_position
	
	$DashDurationTimer.start()
	$DashAvailable.start()


func _on_DashDurationTimer_timeout():
	SPEED = PreviousSpeed
	CAN_HURT = true


func _on_DashAvailable_timeout():
	CAN_DASH = true
