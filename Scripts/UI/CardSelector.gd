extends Control


onready var Game = get_node("/root/Game")
onready var Player = get_node("/root/Game/Player")


func _ready():
	$AnimationPlayer.play("CardsSpawn")
	get_tree().paused = true


# ATTACK INCREASE BUTTON
func _on_AttackIncrease_mouse_entered():
	if $AnimationPlayer.is_playing():
		return
	$AttackIncrease/AttackIncreaseHover.play("AttackIncreaseHover")

func _on_AttackIncrease_mouse_exited():
	if $AnimationPlayer.is_playing():
		return
	$AttackIncrease/AttackIncreaseHover.play("AttackIncreaseHoverOff")

func _on_AttackIncrease_button_down():
	if $AnimationPlayer.is_playing():
		return
	$AttackIncrease/AttackIncreaseHover.play("RESET")

func _on_AttackIncrease_pressed():
	if $AnimationPlayer.is_playing():
		return
	Player.DAMAGE += 1
	Game.ATTACK_COUNT += 1
	Game.UPGRADE_COUNT -= 1
	cardSelected()



# HEALTH INCREASE BUTTON
func _on_HealthIncrease_mouse_entered():
	if $AnimationPlayer.is_playing():
		return
	$HealthIncrease/HealthIncreaseHover.play("HealthIncreaseHover")

func _on_HealthIncrease_mouse_exited():
	if $AnimationPlayer.is_playing():
		return
	$HealthIncrease/HealthIncreaseHover.play("HealthIncreaseHoverOff")

func _on_HealthIncrease_button_down():
	if $AnimationPlayer.is_playing():
		return
	$HealthIncrease/HealthIncreaseHover.play("RESET")

func _on_HealthIncrease_pressed():
	if $AnimationPlayer.is_playing():
		return
	Player.HEALTH += 1
	Player.MAX_HEALTH += 1
	Game.HEALTH_COUNT += 1
	Game.UPGRADE_COUNT -= 1
	cardSelected()



# SPEED INCREASE BUTTON
func _on_SpeedIncrease_mouse_entered():
	if $AnimationPlayer.is_playing():
		return
	$SpeedIncrease/SpeedIncreaseHover.play("SpeedIncreaseHover")

func _on_SpeedIncrease_mouse_exited():
	if $AnimationPlayer.is_playing():
		return
	$SpeedIncrease/SpeedIncreaseHover.play("SpeedIncreaseHoverOff")

func _on_SpeedIncrease_button_down():
	if $AnimationPlayer.is_playing():
		return
	$SpeedIncrease/SpeedIncreaseHover.play("RESET")

func _on_SpeedIncrease_pressed():
	if $AnimationPlayer.is_playing():
		return
	Player.SPEED += 25
	Player.SHOOT_SPEED *= 0.9
	Game.SPEED_COUNT += 1
	Game.UPGRADE_COUNT -= 1
	cardSelected()



func cardSelected() -> void:
	get_parent().queue_free()
	get_tree().paused = false
