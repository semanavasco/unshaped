extends Node2D


onready var Game = get_node("/root/Game")


func _process(_delta):
	$AttackCount.text = String(Game.ATTACK_COUNT)
	$HealthCount.text = String(Game.HEALTH_COUNT)
	$SpeedCount.text = String(Game.SPEED_COUNT)
	$UpgradesCount.text = String(Game.UPGRADE_COUNT)
	
	if GameSettings.ACTIVATE_UPGRADE_MENU == true:
		if $UpgradesCount.visible == true:
			$UpgradesCount.visible = false
		if $SUpgrades.visible == true:
			$SUpgrades.visible = false
	elif GameSettings.ACTIVATE_UPGRADE_MENU == false:
		if $UpgradesCount.visible == false:
			$UpgradesCount.visible = true
		if $SUpgrades.visible == false:
			$SUpgrades.visible = true
