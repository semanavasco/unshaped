extends Area2D


export(int) var BONUS = 100


onready var Player = get_node("/root/Game/Player")
onready var Game = get_node("/root/Game")
onready var SwordTimer = get_parent().get_node("SwordTimer")


const ScoreIndicator = preload("res://Scenes/UI/ScoreIndicator.tscn")
const SwordBoost = preload("res://Scenes/Boosts/SwordBoost.tscn")


func _ready():
	$AnimationPlayer.play("SwordIdle")


func _on_Sword_body_entered(body):
	if "Player" in body.get_name():
		if Player.BOOSTS == "None":
			initiateBoost("Sword")
			queue_free()
		elif Player.BOOSTS == "Dash":
			Game.SCORE += BONUS
			spawnScoreIndicator("+" + String(BONUS))
			queue_free()
		elif Player.BOOSTS == "Sword":
			var CurrentSwordBoost = get_parent().get_node("SwordBoost")
			CurrentSwordBoost.TIME_LEFT = 10
			CurrentSwordBoost.ROTATION_SPEED += 50
			queue_free()


func spawnScoreIndicator(score) -> void:
	var effect = ScoreIndicator.instance()
	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position
	
	effect.label.text = String(score)


func initiateBoost(boost) -> void:
	if boost == "Sword":
		Player.BOOSTS = "Sword"
		var SpawnedSword = SwordBoost.instance()
		get_tree().current_scene.add_child(SpawnedSword)
		SwordTimer.visible = true
