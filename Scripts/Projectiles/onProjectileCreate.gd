extends KinematicBody2D

export var speed = 300

var velocity = Vector2.ZERO

func _physics_process(delta):
	position += velocity.normalized() * delta * speed
	
	if not $VisibilityNotifier2D.is_on_screen():
		queue_free()
