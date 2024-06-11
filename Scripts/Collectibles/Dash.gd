extends Area2D


export(int) var BONUS = 100


onready var Player = get_parent().get_node("Player")
onready var Game = get_node("/root/Game")


const ScoreIndicator = preload("res://Scenes/UI/ScoreIndicator.tscn")


func _ready():
	$AnimationPlayer.play("DashIdle")


func _on_Dash_body_entered(body):
	if "Player" in body.get_name():
		if Player.BOOSTS == "None":
			Player.BOOSTS = "Dash"
			Player.DASH_TIME_LEFT = Player.DASH_TIME_BONUS
			queue_free()
		elif Player.BOOSTS == "Sword":
			Game.SCORE += BONUS
			spawnScoreIndicator("+" + String(BONUS))
			queue_free()
		elif Player.BOOSTS == "Dash":
			Player.DASH_TIME_LEFT = Player.DASH_TIME_BONUS
			queue_free()


func spawnScoreIndicator(score) -> void:
	var effect = ScoreIndicator.instance()
	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position
	
	effect.label.text = String(score)
