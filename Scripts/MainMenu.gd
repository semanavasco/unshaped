extends Node2D


var ScreenSize


const Cursor = preload("res://Assets/UI/sShootCursor.png")


func _ready():
	ScreenSize = get_viewport_rect().size
	
	$HighScore/AnimationPlayer.play("HighScoreIdle")
	$LastScore/AnimationPlayer.play("LastScoreIdle")
	$HighScore.text = "HIGH SCORE :\n" + String(GameSettings.HIGH_SCORE)
	$LastScore.text = "LAST SCORE :\n" + String(GameSettings.LAST_SCORE)

func _process(delta):
	var direction = (get_global_mouse_position()  - Vector2(ScreenSize.x / 2, ScreenSize.y / 2)).normalized() 
	
	$UNSHAPED.rect_position += direction * delta * -50
	
	$UNSHAPED.rect_position.x = clamp($UNSHAPED.rect_position.x, 220, 250)
	$UNSHAPED.rect_position.y = clamp($UNSHAPED.rect_position.y, 50, 70)


func _on_PlayButton_mouse_entered():
	$PlayButton/AnimationPlayer.play("PlayButtonHover")


func _on_PlayButton_mouse_exited():
	$PlayButton/AnimationPlayer.play("PlayButtonUnhover")


func _on_OptionsButton_mouse_entered():
	$OptionsButton/AnimationPlayer.play("OptionsHover")


func _on_OptionsButton_mouse_exited():
	$OptionsButton/AnimationPlayer.play("OptionsUnhover")


func _on_QuitButton_mouse_entered():
	$QuitButton/AnimationPlayer.play("QuitHover")


func _on_QuitButton_mouse_exited():
	$QuitButton/AnimationPlayer.play("QuitUnhover")


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://Scenes/OptionsMenu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_QuestionMark_mouse_entered():
	$QuestionMark/AnimationPlayer.play("QuestionHover")


func _on_QuestionMark_mouse_exited():
	$QuestionMark/AnimationPlayer.play("QuestionUnhover")


func _on_QuestionMark_pressed():
	get_tree().change_scene("res://Scenes/UI/Keybinds.tscn")
