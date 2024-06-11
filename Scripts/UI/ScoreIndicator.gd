extends Node2D

export(int) var SPEED = 30
export(int) var FRICTION = 15


var SHIFT_DIRECTION = Vector2.ZERO


onready var label = $Label


func _ready():
	SHIFT_DIRECTION = Vector2(rand_range(-1, 1), rand_range(-1, 1))


func _process(delta):
	global_position += SPEED * delta * SHIFT_DIRECTION
	SPEED = max(SPEED - FRICTION * delta, 0)
