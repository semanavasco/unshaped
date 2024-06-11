extends AnimatedSprite


func _ready():
	$AnimationPlayer.play("OnScreenHitLoad")


func _process(_delta):
	if not $AnimationPlayer.is_playing():
		queue_free()
