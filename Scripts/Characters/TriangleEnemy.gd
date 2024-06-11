extends Area2D


export(int) var SPEED = 150
export(int) var HEALTH = 1
export(bool) var CAN_DIE = false


onready var Player = get_node("/root/Game/Player")
onready var Game = get_node("/root/Game")


const ScoreIndicator = preload("res://Scenes/UI/ScoreIndicator.tscn")
const DamageParticles = preload("res://Scenes/Particles/BlueDamage.tscn")
const Heart = preload("res://Scenes/Collectibles/Heart.tscn")
const Sword = preload("res://Scenes/Collectibles/Sword.tscn")
const Bomb = preload("res://Scenes/Collectibles/Bomb.tscn")
const Dash = preload("res://Scenes/Collectibles/Dash.tscn")


var ImunityTimer


func _ready():
	if Game.PHASE > 1:
		HEALTH += Game.PHASE - 1
	
	ImunityTimer = Timer.new()
	add_child(ImunityTimer)
	
	ImunityTimer.connect("timeout", self, "_on_Timer_timeout")
	ImunityTimer.set_wait_time(0.25)
	ImunityTimer.set_one_shot(true)
	ImunityTimer.start()


func _physics_process(delta):
	var direction = (Player.position - position).normalized() 
	
	position += direction * delta * SPEED
	
	$AnimatedSprite.flip_h = direction.x < 0


func _on_TriangleEnemy_body_entered(body):
	if "TriangleProjectile" in body.get_name():
		HEALTH -= Player.DAMAGE
		body.queue_free()
		Game.SCORE += 5
		spawnScoreIndicator("+5")
		
		var DamageEffect = DamageParticles.instance()
		DamageEffect.global_position = global_position
		get_parent().add_child(DamageEffect)
		
		if HEALTH <= 0:
			Game.KILLED_ENEMIES += 1
			spawnCollectible()
			queue_free()
	
	if "SwordHitBox" in body.get_name():
		if CAN_DIE == false:
			return
		
		HEALTH -= Player.DAMAGE
		Game.SCORE += 5
		spawnScoreIndicator("+5")
		
		var DamageEffect = DamageParticles.instance()
		DamageEffect.global_position = global_position
		get_parent().add_child(DamageEffect)
		
		if HEALTH <= 0:
			Game.KILLED_ENEMIES += 1
			spawnCollectible()
			queue_free()
	
	if "BombExplosionHitBox" in body.get_name():
		if CAN_DIE == false:
			return
		
		Game.KILLED_ENEMIES += 1
		queue_free()
		Game.SCORE += 10
		spawnScoreIndicator("+10")


func spawnScoreIndicator(score):
	var effect = ScoreIndicator.instance()
	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position
	
	effect.label.text = String(score)


func spawnCollectible() -> void:
	var randomNumber = (randi() % 23 + 1)
	var generateHeart = randomNumber == 21
	var generateSword = randomNumber == 22
	var generateDash = randomNumber == 23
	
	if Game.KILLED_ENEMIES % 50 == 0:
		var SpawnedBomb = Bomb.instance()
		get_parent().add_child(SpawnedBomb)
		SpawnedBomb.global_position = global_position
	elif generateHeart == true:
		var spawnedHeart = Heart.instance()
		get_tree().current_scene.add_child(spawnedHeart)
		spawnedHeart.global_position = global_position
	elif generateSword == true:
		var spawnedSword = Sword.instance()
		get_tree().current_scene.add_child(spawnedSword)
		spawnedSword.global_position = global_position
	elif generateDash == true:
		var spawnedDash = Dash.instance()
		get_tree().current_scene.add_child(spawnedDash)
		spawnedDash.global_position = global_position


func _on_Timer_timeout():
	CAN_DIE = true
	ImunityTimer.queue_free()
