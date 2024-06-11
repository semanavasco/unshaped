extends Node


export(int) var HIGH_SCORE = 0
export(int) var LAST_SCORE = 0
export(bool) var ACTIVATE_UPGRADE_MENU = true
export(bool) var TOGGLE_FULLSCREEN = false


var GameData = {
	"highScore": HIGH_SCORE,
	"lastScore": LAST_SCORE,
	"activateUpgradeMenu": ACTIVATE_UPGRADE_MENU,
	"toggleFullScreen": TOGGLE_FULLSCREEN,
}


const SAVE_FILE_PATH = "user://save.save"


func _ready():
	loadData()
	
	OS.window_fullscreen = TOGGLE_FULLSCREEN


func saveData():
	GameData = {
		"highScore": HIGH_SCORE,
		"lastScore": LAST_SCORE,
		"activateUpgradeMenu": ACTIVATE_UPGRADE_MENU,
		"toggleFullScreen": TOGGLE_FULLSCREEN,
	}
	
	var file = File.new()
	
	file.open(SAVE_FILE_PATH, file.WRITE)
	
	file.store_var(GameData)
	
	file.close()


func loadData():
	var file = File.new()
	
	if not file.file_exists(SAVE_FILE_PATH):
		GameData = {
			"highScore": 0,
			"lastScore": 0,
			"activateUpgradeMenu": false,
			"toggleFullScreen": false,
		}
		
		saveData()
	
	file.open(SAVE_FILE_PATH, file.READ)
	
	GameData = file.get_var()
	
	HIGH_SCORE = GameData.highScore
	LAST_SCORE = GameData.lastScore
	ACTIVATE_UPGRADE_MENU = GameData.activateUpgradeMenu
	TOGGLE_FULLSCREEN = GameData.toggleFullScreen
	
	file.close()
