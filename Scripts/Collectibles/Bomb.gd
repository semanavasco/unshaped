extends Area2D


const BombExplosion = preload("res://Scenes/Projectiles/BombExplosion.tscn")

onready var Player = get_parent().get_node("Player")


func _ready():
	$AnimationPlayer.play("BombIdle")


func _on_Bomb_body_entered(body):
	if "Player" in body.get_name():
		var BombExplosionInstance = BombExplosion.instance()
		get_parent().add_child(BombExplosionInstance)
		BombExplosionInstance.global_position = Player.global_position
		queue_free()
