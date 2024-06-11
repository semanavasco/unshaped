extends Control


func _ready():
	get_tree().paused = true
	
	$AnimationPlayer.play("OnMenuOpen")
	$HighScore/AnimationPlayer.play("LastScoreIdle")
	$Score/AnimationPlayer.play("HighScoreIdle")
	
	$Score.text = "SCORE :\n" + String(get_parent().get_parent().SCORE)
	$HighScore.text = "HIGH SCORE :\n" + String(GameSettings.HIGH_SCORE)


func _on_RetryButton_mouse_entered():
	if $AnimationPlayer.is_playing():
		return
	$RetryButton/AnimationPlayer.play("ResumeHover")


func _on_RetryButton_mouse_exited():
	if $AnimationPlayer.is_playing():
		return
	$RetryButton/AnimationPlayer.play("ResumeUnhover")


func _on_MenuButton_mouse_entered():
	if $AnimationPlayer.is_playing():
		return
	$MenuButton/AnimationPlayer.play("OptionsHover")


func _on_MenuButton_mouse_exited():
	if $AnimationPlayer.is_playing():
		return
	$MenuButton/AnimationPlayer.play("OptionsUnhover")


func _on_QuitButton_mouse_entered():
	if $AnimationPlayer.is_playing():
		return
	$QuitButton/AnimationPlayer.play("QuitHover")


func _on_QuitButton_mouse_exited():
	if $AnimationPlayer.is_playing():
		return
	$QuitButton/AnimationPlayer.play("QuitUnhover")


func _on_RetryButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_MenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
