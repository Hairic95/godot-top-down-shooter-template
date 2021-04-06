extends Node2D

var player

func _ready():
	$CameraHandler.global_position = $Arena.global_position
	player = $Entities/Player
	
	for child in $Entities.get_children():
		if child is Enemy:
			child.player = player
	
	EventBus.connect("create_bullet", self, "create_bullet")
	EventBus.connect("create_effect", self, "create_effect")

func create_bullet(bullet_instance, start_pos, direction):
	bullet_instance.global_position = start_pos
	bullet_instance.direction = direction.normalized()
	$Bullets.add_child(bullet_instance)

func create_effect(effect_instance, start_pos):
	effect_instance.global_position = start_pos
	$Effects.add_child(effect_instance)

func _process(delta):
	if player.active:
		var new_camera_pos =  $Arena.global_position
		if player.shooting_direction.y < 0:
			new_camera_pos.y -= 10
		if player.shooting_direction.y > 0:
			new_camera_pos.y += 10
		if player.shooting_direction.x < 0:
			new_camera_pos.x -= 10
		if player.shooting_direction.x > 0:
			new_camera_pos.x += 10
		if (player.global_position - $Arena.global_position).y > 40:
			new_camera_pos.y += (player.global_position - $Arena.global_position).y / 5
		elif (player.global_position - $Arena.global_position).y < 40:
			new_camera_pos.y += (player.global_position - $Arena.global_position).y / 5
		
		$CameraHandler.global_position = new_camera_pos
