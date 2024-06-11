extends Node2D


export(float) var TIME_LEFT = 10
export(int) var BONUS_TIME = 10
export(int) var ROTATION_SPEED = 150


onready var Player = get_parent().get_node("Player")
onready var SwordTimer = get_parent().get_node("SwordTimer")


var SwordTimeBar
var DisabledTimer


func _ready():
	SwordTimeBar = SwordTimer.get_node("SwordTimeBar")
	
	global_position = Player.global_position
	
	DisabledTimer = Timer.new()
	add_child(DisabledTimer)
	
	DisabledTimer.connect("timeout", self, "_on_Timer_timeout")
	DisabledTimer.set_wait_time(0.05)
	DisabledTimer.set_one_shot(false)
	DisabledTimer.start()


func _physics_process(delta):
	if TIME_LEFT <= 0:
		DisabledTimer.queue_free()
		Player.BOOSTS = "None"
		SwordTimer.visible = false
		queue_free()
	
	rotation_degrees += ROTATION_SPEED * delta
	global_position = Player.global_position
	
	SwordTimeBar.value = TIME_LEFT


func _on_Timer_timeout():
	TIME_LEFT -= 0.05
