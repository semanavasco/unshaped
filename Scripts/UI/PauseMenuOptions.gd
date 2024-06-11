extends Control


var ScreenSize


onready var CheckButtonOn = preload("res://Assets/UI/sCheckButtonOn.png")
onready var CheckButtonOff = preload("res://Assets/UI/sCheckButton.png")


func _ready():
	ScreenSize = get_viewport_rect().size
	
	if not GameSettings.ACTIVATE_UPGRADE_MENU:
		$CheckButton.texture_normal = CheckButtonOff
	else:
		$CheckButton.texture_normal = CheckButtonOn
	
	if not GameSettings.TOGGLE_FULLSCREEN:
		$FullScreenButton.texture_normal = CheckButtonOff
	else:
		$FullScreenButton.texture_normal = CheckButtonOn

func _process(delta):
	var direction = (get_global_mouse_position()  - Vector2(ScreenSize.x / 2, ScreenSize.y / 2)).normalized() 
	
	$OPTIONS.rect_position += direction * delta * -50
	
	$OPTIONS.rect_position.x = clamp($OPTIONS.rect_position.x, 220, 250)
	$OPTIONS.rect_position.y = clamp($OPTIONS.rect_position.y, 50, 70)
	
	if Input.is_action_just_pressed("pause"):
		if not get_parent().visible:
			return
		var PauseMenu = get_parent().get_parent().get_node("PauseMenu")
		PauseMenu.visible = true
		get_parent().queue_free()


func _on_CheckButton_mouse_entered():
	$CheckButton/AnimationPlayer.play("CheckButtonHover")
	$SPopUpUpgradeMenu.visible = true


func _on_CheckButton_mouse_exited():
	$CheckButton/AnimationPlayer.play("CheckButtonUnhover")
	$SPopUpUpgradeMenu.visible = false


func _on_CheckButton_pressed():
	GameSettings.ACTIVATE_UPGRADE_MENU = not GameSettings.ACTIVATE_UPGRADE_MENU
	
	if not GameSettings.ACTIVATE_UPGRADE_MENU:
		$CheckButton.texture_normal = CheckButtonOff
	else:
		$CheckButton.texture_normal = CheckButtonOn


func _on_BackButton_mouse_entered():
	$BackButton/AnimationPlayer.play("BackHover")


func _on_BackButton_mouse_exited():
	$BackButton/AnimationPlayer.play("BackUnhover")


func _on_BackButton_pressed():
	var PauseMenu = get_parent().get_parent().get_node("PauseMenu")
	PauseMenu.visible = true
	get_parent().queue_free()


func _on_FullScreenButton_mouse_entered():
	$FullScreenButton/AnimationPlayer.play("CheckButtonHover")
	$SPopUpFullscreen.visible = true


func _on_FullScreenButton_mouse_exited():
	$FullScreenButton/AnimationPlayer.play("CheckButtonUnhover")
	$SPopUpFullscreen.visible = false


func _on_FullScreenButton_pressed():
	GameSettings.TOGGLE_FULLSCREEN = not GameSettings.TOGGLE_FULLSCREEN
	
	if not GameSettings.TOGGLE_FULLSCREEN:
		$FullScreenButton.texture_normal = CheckButtonOff
	else:
		$FullScreenButton.texture_normal = CheckButtonOn
	
	OS.window_fullscreen = GameSettings.TOGGLE_FULLSCREEN
	
	GameSettings.saveData()
