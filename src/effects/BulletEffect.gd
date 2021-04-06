extends Sprite

func _ready():
	$Anim.play("Effect")

func _on_Anim_animation_changed(old_name, new_name):
	queue_free()
