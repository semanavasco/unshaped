extends Node2D


export(bool) var CAN_SHOOT = true
export(int) var SPEED = 200
export(float) var SHOOT_SPEED = 0.5
export(bool) var CAN_DASH = true


var ScreenSize
var AttackTimer
var PreviousSpeed


const SquareProjectile = preload("res://Scenes/Projectiles/SquareProjectile.tscn")
const TriangleProjectile = preload("res://Scenes/Projectiles/TriangleProjectile.tscn")
const PlayerDash = preload("res://Scenes/Particles/PlayerDash.tscn")


func _ready():
	ScreenSize = get_viewport_rect().size
	$DashTimer/DashTimeBar.value = 10


func _physics_process(delta):
	if CAN_SHOOT == false:
		$Area2D/Cursor.visible = false
	else:
		$Area2D/Cursor.visible = true
	
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
			shoot($Area2D/Cursor.animation)
	if Input.is_action_just_pressed("dash"):
		dash()
	
	if velocity.length() > 0:
		velocity = velocity.normalized()
		$Area2D/AnimatedSprite.animation = "Walk"
		$Area2D/AnimatedSprite.play()
	else:
		$Area2D/AnimatedSprite.animation = "Idle"
		$Area2D/AnimatedSprite.stop()
	
	$Area2D.position += velocity * delta * SPEED
	$Area2D.position.x = clamp($Area2D.position.x, 0, ScreenSize.x)
	$Area2D.position.y = clamp($Area2D.position.y, 0, ScreenSize.y)
	
	if velocity.x != 0:
		$Area2D/AnimatedSprite.flip_h = velocity.x < 0
	
	$Area2D/Cursor.look_at(get_global_mouse_position())

func switch():
	if $Area2D/Cursor.animation == "Square":
		$Area2D/Cursor.animation = "Triangle"
	else: $Area2D/Cursor.animation = "Square"


func shoot(shape):
	var ProjectileInstance
	var ProjectileRotation = $Area2D/Cursor.rotation_degrees
	var ProjectilePosition = $Area2D/Cursor/Position2D.global_position
	
	if shape == "Square":
		ProjectileInstance = SquareProjectile.instance()
	else: ProjectileInstance = TriangleProjectile.instance()
	
	ProjectileInstance.rotation_degrees = ProjectileRotation
	ProjectileInstance.position = ProjectilePosition
	
	get_parent().add_child(ProjectileInstance)
	
	ProjectileInstance.velocity = get_global_mouse_position() - $Area2D.global_position
	
	create_AttackTimer()


func create_AttackTimer() -> void:
	AttackTimer = Timer.new()
	add_child(AttackTimer)
	
	AttackTimer.connect("timeout", self, "_on_Timer_timeout")
	AttackTimer.set_wait_time(SHOOT_SPEED)
	AttackTimer.set_one_shot(true)
	AttackTimer.start()


func dash():
	if not CAN_DASH:
		return
	CAN_DASH = false
	PreviousSpeed = SPEED
	SPEED *= 3
	
	var PlayerDashEffect = PlayerDash.instance()
	$Area2D.add_child(PlayerDashEffect)
	PlayerDashEffect.global_position = $Area2D.global_position
	
	$Area2D/DashDurationTimer.start()
	$Area2D/DashAvailable.start()


func _on_DashDurationTimer_timeout():
	SPEED = PreviousSpeed


func _on_DashAvailable_timeout():
	CAN_DASH = true


func _on_Timer_timeout():
	CAN_SHOOT = true
	AttackTimer.queue_free()


func _on_Cross_mouse_entered():
	$Cross/AnimationPlayer.play("CrossHover")


func _on_Cross_mouse_exited():
	$Cross/AnimationPlayer.play("CrossUnhover")


func _on_Cross_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
