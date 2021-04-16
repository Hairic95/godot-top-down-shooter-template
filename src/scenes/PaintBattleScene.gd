extends Node2D


var player
var latest_player_position : Vector2 = Vector2.ZERO


func _ready():
	player = $Entities/Player1
	latest_player_position = player.global_position
	
	$CanvasLayer/Player1Percentage.add_color_override("font_color", $Entities/Player1.paint_color)
	$CanvasLayer/Player1Percentage.add_color_override("font_outline_modulate", $Entities/Player1.paint_color.darkened(.4))
	$CanvasLayer/Player2Percentage.add_color_override("font_color", $Entities/Player2.paint_color)
	$CanvasLayer/Player2Percentage.add_color_override("font_outline_modulate", $Entities/Player2.paint_color.darkened(.4))
	
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
						var old_color = image.get_pixelv(final_pixel)
						if mask_image.get_pixel(x, y).r == 1 && old_color.to_html() != paint_color.to_html():
							
							image.set_pixelv(final_pixel, paint_color.darkened(.4))
						else:
							image.set_pixelv(final_pixel, paint_color)
	
	var new_texture = ImageTexture.new()
	new_texture.create_from_image(image, Texture.FLAG_VIDEO_SURFACE)
	$ArenaPaint.texture = new_texture

func _on_MatchTimer_timeout():
	print("match finished")

func _on_UpdateUITimer_timeout():
	var time_left = str(int($MatchTimer.time_left))
	$CanvasLayer/TimeLeft1.text = time_left
	$CanvasLayer/TimeLeft2.text = time_left
	$CanvasLayer/TimeLeft3.text = time_left
	$CanvasLayer/TimeLeft4.text = time_left
	
	var imageTexture = $ArenaPaint.texture
	var image = imageTexture.get_data()
	image.lock()
	
	var player1_pixels = 0.0
	var player2_pixels = 0.0
	var total_pixels = 0.0
	
	for x in image.get_width():
		for y in image.get_height():
			var color = image.get_pixel(x, y).to_rgba32()
			
			if color == $Entities/Player1.paint_color.to_rgba32():
				player1_pixels += 1.0
			elif color == $Entities/Player2.paint_color.to_rgba32():
				player2_pixels += 1.0
			
			total_pixels += 1.0
	
	print(player1_pixels)
	
	$CanvasLayer/Player1Percentage.text = str(int(player1_pixels / total_pixels * 100.0))
	$CanvasLayer/Player2Percentage.text = str(int(player2_pixels / total_pixels * 100.0))
	
