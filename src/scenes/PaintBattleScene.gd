extends Node2D


var player
var latest_player_position : Vector2 = Vector2.ZERO


func _ready():
	player = $Entities/Player1
	latest_player_position = player.global_position
	
	EventBus.connect("create_bullet", self, "create_bullet")
	EventBus.connect("create_effect", self, "create_effect")
	EventBus.connect("create_paint_mask", self, "create_paint_mask")

func _process(delta):
	if player != null:
		latest_player_position = player.global_position
		if player.active:
			var new_camera_pos =  $ArenaBackground.global_position
			if player.shooting_direction.y < 0:
				new_camera_pos.y -= 10
			if player.shooting_direction.y > 0:
				new_camera_pos.y += 10
			if player.shooting_direction.x < 0:
				new_camera_pos.x -= 10
			if player.shooting_direction.x > 0:
				new_camera_pos.x += 10
			if (player.global_position - $ArenaBackground.global_position).y > 40:
				new_camera_pos.y += (player.global_position - $ArenaBackground.global_position).y / 5
			elif (player.global_position - $ArenaBackground.global_position).y < 40:
				new_camera_pos.y += (player.global_position - $ArenaBackground.global_position).y / 5
			
			$CameraHandler.global_position = new_camera_pos

func create_bullet(bullet_instance, start_pos, direction):
	bullet_instance.global_position = start_pos
	bullet_instance.direction = direction.normalized()
	$Bullets.add_child(bullet_instance)

func create_effect(effect_instance, start_pos):
	effect_instance.global_position = start_pos
	$Effects.add_child(effect_instance)

func create_paint_mask(mask_global_position, mask_texture, paint_color):
	
	var imageTexture = $ArenaPaint.texture
	var image = imageTexture.get_data()
	image.lock()
	var mask_image = mask_texture.get_data()
	mask_image.lock()
	
	var arena_mask_image = $ArenaMask.texture.get_data()
	arena_mask_image.lock()
	
	for x in mask_image.get_width():
		for y in mask_image.get_height():
			if mask_image.get_pixel(x, y).a == 1:
				
				var final_pixel = mask_global_position + Vector2(x, y) + image.get_size() / 2 - mask_image.get_size() / 2
				var image_rect = Rect2(0, 0, image.get_width(), image.get_height())
				if image_rect.has_point(final_pixel):
					if arena_mask_image.get_pixelv(final_pixel).a != 0:
						if mask_image.get_pixel(x, y).r == 1 && image.get_pixelv(final_pixel).a != 1:
							image.set_pixelv(final_pixel, paint_color * .7)
						else:image.set_pixelv(final_pixel, paint_color)
							
	
	var new_texture = ImageTexture.new()
	new_texture.create_from_image(image, Texture.FLAG_VIDEO_SURFACE)
	$ArenaPaint.texture = new_texture
	
