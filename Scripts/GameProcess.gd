extends Node2D


export(int) var SCORE = 0
export(int) var KILLED_ENEMIES = 0
export(int) var CARD_PHASE = 0
export(int) var PHASE = 1
export(int) var KILLING_PHASE = 1
export(float) var SPAWN_TIME = 1
export(bool) var IS_BOSS_FIGHT = false


export(int) var ATTACK_COUNT = 0
export(int) var HEALTH_COUNT = 0
export(int) var SPEED_COUNT = 0
export(int) var UPGRADE_COUNT = 0


onready var TriangleEnemy = preload("res://Scenes/Characters/TriangleEnemy.tscn")
onready var SquareEnemy = preload("res://Scenes/Characters/SquareEnemy.tscn")
onready var LozengeEnemy = preload("res://Scenes/Characters/LozengeEnemy.tscn")
onready var CardSelector = preload("res://Scenes/UI/CardSelector.tscn")
onready var PauseMenu = preload("res://Scenes/UI/PauseMenu.tscn")


var EnemyPositions 
var EnemyShapes
var RandomPosition
var RandomShape
var SpawnTimer
var ScreenSize


onready var Player = get_node("Player")


const ScoreIndicator = preload("res://Scenes/UI/ScoreIndicator.tscn")


func _ready():
	ScreenSize = get_viewport_rect().size
	EnemyPositions = [$EnemySpawner/TopLeft.global_position, $EnemySpawner/TopLeftCenter.global_position, $EnemySpawner/TopRightCenter.global_position, $EnemySpawner/TopRight.global_position, $EnemySpawner/CenterRight.global_position, $EnemySpawner/BottomRight.global_position, $EnemySpawner/BottomRightCenter.global_position, $EnemySpawner/BottomLeftCenter.global_position, $EnemySpawner/BottomLeft.global_position, $EnemySpawner/CenterLeft.global_position]
	EnemyShapes = [TriangleEnemy, SquareEnemy, LozengeEnemy]

	SpawnTimer = Timer.new()
	add_child(SpawnTimer)
	
	SpawnTimer.connect("timeout", self, "_on_Timer_timeout")
	SpawnTimer.set_wait_time(SPAWN_TIME)
	SpawnTimer.set_one_shot(false)
	SpawnTimer.start()


func _on_Timer_timeout():
	if KILLED_ENEMIES < 20:
		PHASE = 1
	elif KILLED_ENEMIES > 20 and KILLED_ENEMIES < 40:
		PHASE = 2
	elif KILLED_ENEMIES > 40:
		PHASE = 3
	
	SpawnTimer.set_wait_time(SPAWN_TIME)
	
	RandomPosition = randi() % 10
	RandomShape = randi() % PHASE
	
	if not IS_BOSS_FIGHT:
		spawnEnemy(RandomPosition, RandomShape)


func spawnEnemy(rngPos, rngShape):
	var EnemySpawned = EnemyShapes[rngShape].instance()
	
	add_child(EnemySpawned)
	
	EnemySpawned.position = EnemyPositions[rngPos]

func _process(_delta):
	$SBackgroundOverlay/UserInterface/Label.text = String(SCORE)
	
	$Life/Label.text = String(Player.HEALTH)
	$Life/HpBar.value = Player.HEALTH
	$Life/HpBar.max_value = Player.MAX_HEALTH
	
	if KILLED_ENEMIES == 10 + (CARD_PHASE * 10):
		CARD_PHASE += 1
		UPGRADE_COUNT += 1
		
		if GameSettings.ACTIVATE_UPGRADE_MENU == true:
			var CardSelectorMenu = CardSelector.instance()
			add_child(CardSelectorMenu)
		else:
			upgradeIndicator("AN UPGRADE IS AVAILABLE")
	
	
	if Input.is_action_just_pressed("attack_upgrade") and GameSettings.ACTIVATE_UPGRADE_MENU == false and UPGRADE_COUNT >= 1:
		$Player.DAMAGE += 1
		ATTACK_COUNT += 1
		UPGRADE_COUNT -= 1
		upgradeIndicator("+1 DAMAGE")
	if Input.is_action_just_pressed("health_upgrade") and GameSettings.ACTIVATE_UPGRADE_MENU == false and UPGRADE_COUNT >= 1:
		$Player.HEALTH += 1
		$Player.MAX_HEALTH += 1
		HEALTH_COUNT += 1
		UPGRADE_COUNT -= 1
		upgradeIndicator("+1 HEALTH")
	if Input.is_action_just_pressed("speed_upgrade") and GameSettings.ACTIVATE_UPGRADE_MENU == false and UPGRADE_COUNT >= 1:
		$Player.SPEED += 25
		$Player.SHOOT_SPEED *= 0.9
		SPEED_COUNT += 1
		UPGRADE_COUNT -= 1
		upgradeIndicator("+1 SPEED")
	if Input.is_action_just_pressed("upgrade_menu") and GameSettings.ACTIVATE_UPGRADE_MENU == false and UPGRADE_COUNT >= 1:
		var CardSelectorMennu = CardSelector.instance()
		add_child(CardSelectorMennu)
	if Input.is_action_just_pressed("pause"):
		pause()


func pause():
	var PauseMenuInstance = PauseMenu.instance()
	add_child(PauseMenuInstance)


func upgradeIndicator(score) -> void:
	var effect = ScoreIndicator.instance()
	get_tree().current_scene.add_child(effect)
	effect.position = Vector2(ScreenSize.x / 2, ScreenSize.y / 4)
	
	effect.label.text = String(score)
