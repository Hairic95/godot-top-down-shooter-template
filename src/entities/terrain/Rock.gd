extends StaticBody2D

func _ready():
	randomize()
	$Sprite.frame = randi()%$Sprite.hframes


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
