extends Node2D

func _ready():
	set_writing()
	$Anim.play("Effect_001")

func set_writing():
	$Writing/Label.text = "Spooky Time"

func _on_Anim_animation_finished(anim_name):
	EventBus.emit_signal("change_scene", "battle")
