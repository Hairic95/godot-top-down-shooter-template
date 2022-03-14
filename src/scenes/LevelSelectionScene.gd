extends Node2D

var current_level_grid_position = Vector2.ZERO
onready var current_level = $Levels/LevelSelector

func _ready():
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		move_level_cursor(Vector2.UP)
	elif Input.is_action_just_pressed("ui_down"):
		move_level_cursor(Vector2.DOWN)
	elif Input.is_action_just_pressed("ui_right"):
		move_level_cursor(Vector2.RIGHT)
	elif Input.is_action_just_pressed("ui_left"):
		move_level_cursor(Vector2.LEFT)
	elif Input.is_action_just_pressed("ui_accept"):
		if current_level != null && current_level.battle_level != null:
			EventBus.emit_signal("create_scene", current_level.battle_level)

func move_level_cursor(direction):
	for level in $Levels.get_children():
		if level.grid_position == current_level_grid_position + direction:
			current_level_grid_position += direction
			current_level = level
			$UI/TitleLevel.text = level.level_title
			break

func _process(delta):
	if current_level != null && $CameraHandler.global_position != current_level.global_position:
		
		if ($CameraHandler.global_position - current_level.global_position).length() < 1:
			$CameraHandler.global_position = current_level.global_position
		else:
			$CameraHandler.global_position = lerp($CameraHandler.global_position, current_level.global_position, .2)
		
