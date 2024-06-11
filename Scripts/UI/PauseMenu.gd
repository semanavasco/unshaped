extends Control


onready var PauseMenuOptions = preload("res://Scenes/UI/PauseMenuOptions.tscn")


var ScreenSize
var ResumeTimer
var TimeLeft = 3


func _ready():
	ScreenSize = get_viewport_rect().size
	get_tree().paused = true


func _process(delta):
	var direction = (get_global_mouse_position() - Vector2(ScreenSize.x / 2, ScreenSize.y / 2)).normalized() 
	
	$PAUSED.rect_position += direction * delta * -50
	
	$PAUSED.rect_position.x = clamp($PAUSED.rect_position.x, 220, 250)
	$PAUSED.rect_position.y = clamp($PAUSED.rect_position.y, 50, 70)
	
	if Input.is_action_just_pressed("pause"):
		if not get_parent().visible:
			return
		unpause()
	
	if TimeLeft <= 0:
		get_tree().paused = false
		get_parent().queue_free()
	
	get_parent().get_node("Count/Counter").text = String(TimeLeft)


func _on_Resume_mouse_entered():
	$ResumeButton/AnimationPlayer.play("ResumeHover")


func _on_Resume_mouse_exited():
	$ResumeButton/AnimationPlayer.play("ResumeUnhover")


func _on_OptionsButton_mouse_entered():
	$OptionsButton/AnimationPlayer.play("OptionsHover")


func _on_OptionsButton_mouse_exited():
	$OptionsButton/AnimationPlayer.play("OptionsUnhover")


func _on_QuitButton_mouse_entered():
	$QuitButton/AnimationPlayer.play("QuitHover")


func _on_QuitButton_mouse_exited():
	$QuitButton/AnimationPlayer.play("QuitUnhover")


func _on_ResumeButton_pressed():
	unpause()


func _on_OptionsButton_pressed():
	get_parent().visible = false
	var PauseMenuOptionsInstance = PauseMenuOptions.instance()
	get_parent().get_parent().add_child(PauseMenuOptionsInstance)


func _on_QuitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func unpause() -> void:
	visible = false
	get_parent().get_node("Count").visible = true
	
	ResumeTimer = Timer.new()
	add_child(ResumeTimer)
	
	ResumeTimer.connect("timeout", self, "_on_Timer_timeout")
	ResumeTimer.set_wait_time(1)
	ResumeTimer.set_one_shot(false)
	ResumeTimer.start()


func _on_Timer_timeout():
	TimeLeft -= 1
