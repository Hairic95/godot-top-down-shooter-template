extends Player
class_name PaintPlayer

export (String, "red", "blue", "yellow", "green") var player_id = "red"

export (Color) var paint_color

var move_paint_timer = .05
var move_paint_timer_value = .05

var color_index = 0
var available_paint_colors = [
	Color("#2967d1"),
	Color("#63c74d"),
	Color("#feae34"),
	Color("#0095e9"),
	Color("#e31024")
]

func _ready():
	pass

func _process(delta):
	if move_paint_timer_value < move_paint_timer:
		move_paint_timer_value += delta
	if current_state == "Move":
		if move_paint_timer_value >= move_paint_timer:
			EventBus.emit_signal("create_paint_mask", global_position, preload("res://assets/textures/battle/test_paint_mask.png"), paint_color)
			move_paint_timer_value = 0
	
	if Input.is_action_just_pressed("next"):
		color_index += 1
		if color_index == available_paint_colors.size():
			color_index = 0
		paint_color = available_paint_colors[color_index]
	elif Input.is_action_just_pressed("prev"):
		color_index -= 1
		if color_index < 0:
			color_index = available_paint_colors.size() - 1
		paint_color = available_paint_colors[color_index]
		


func shoot():
	if bullet_reference != null:
		var bullet_instance = bullet_reference.instance()
		bullet_instance.paint_color = paint_color
		bullet_instance.modulate = paint_color
		EventBus.emit_signal("create_bullet", bullet_instance, global_position + shooting_direction.normalized() * 6, shooting_direction.normalized())
	$Sounds/ShootSound.pitch_scale = 0.4 + randf()
	$Sounds/ShootSound.play()
	$Timers/ReloadTimer.start()
