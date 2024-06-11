extends Area2D


export(int) var BONUS = 100
export(int) var HEALTH = 1


onready var Player = get_node("/root/Game/Player")
onready var Game = get_node("/root/Game")


const ScoreIndicator = preload("res://Scenes/UI/ScoreIndicator.tscn")


func _ready():
	$AnimationPlayer.play("HeartIdle")


func _on_Heart_body_entered(body):
	if "Player" in body.get_name():
		if Player.HEALTH == Player.MAX_HEALTH:
			Game.SCORE += BONUS
			spawnScoreIndicator("+" + String(BONUS))
			queue_free()
		else:
			Player.HEALTH += HEALTH
			queue_free()


func spawnScoreIndicator(score) -> void:
	var effect = ScoreIndicator.instance()
	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position
	
	effect.label.text = String(score)
