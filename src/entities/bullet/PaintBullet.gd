extends PlayerBullet
class_name PaintPlayerBullet

export (Texture) var paint_mask = preload("res://assets/textures/battle/test_paint_mask.png")

var paint_color = Color(1, 1, 1)

var move_paint_timer = .03
var move_paint_timer_value = .03

func _physics_process(delta):
	if move_paint_timer_value < move_paint_timer:
		move_paint_timer_value += delta
	if move_paint_timer_value >= move_paint_timer:
		EventBus.emit_signal("create_paint_mask", global_position, paint_mask, paint_color)
		move_paint_timer_value = 0

func _on_Bullet_body_entered(body):
	if death_effect != null:
		var death_effect_instance = death_effect.instance()
		death_effect_instance.modulate = paint_color
		EventBus.emit_signal("create_effect", death_effect_instance, global_position)
	queue_free()

func _on_Bullet_area_entered(area):
	pass
