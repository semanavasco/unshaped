extends Area2D


func _ready():
	$AnimationPlayer.play("BombExplosion")


func _process(_delta):
	if not $AnimationPlayer.is_playing():
		queue_free()
