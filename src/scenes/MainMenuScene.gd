extends Node2D


func _ready():
	$Character/Anim.play("Idle")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Character/Anim.play("Selected")

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Selected":
		EventBus.emit_signal("change_scene", "level_select")
