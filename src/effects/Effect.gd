extends Sprite

func _ready():
	$Anim.play("Effect")

func _on_Anim_animation_finished(anim_name):
	queue_free()
