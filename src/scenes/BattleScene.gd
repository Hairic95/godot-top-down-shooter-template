extends Node2D

export (Vector2) var arena_center = Vector2(160, 115)
export (Rect2) var arena_borders

var player

var battle_waves = [
	"wave_specter_01",
	"wave_specter_02",
	"wave_specter_03"
]

func _ready():
	$CameraHandler.global_position = $Arena.global_position
	player = $Entities/Player
	
	var i = 0
	
	EventBus.connect("create_bullet", self, "create_bullet")
	EventBus.connect("create_effect", self, "create_effect")
	
	EventBus.connect("enemy_death", self, "enemy_death")
	
	create_wave(battle_waves[0])

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

func create_wave(wave_code):
	var wave_data = WaveCreator.get_wave(wave_code)
	if wave_data != null:
		for enemy_data in wave_data:
			for i in enemy_data.quantity:
				var enemy_instance = enemy_data.reference.instance()
				enemy_instance.player = player
				enemy_instance.arena_borders = arena_borders
				if enemy_instance is SpecterEnemy:
					var starting_angle = 2 * PI / enemy_data.quantity * i
					enemy_instance.global_position = arena_center + Vector2(cos(starting_angle), sin(starting_angle)) * 50
				$Entities.add_child(enemy_instance)
				if enemy_instance is SpecterEnemy:
					update_specter_enemies()

func enemy_death(enemy_type):
	yield(get_tree().create_timer(.000001), "timeout")
	if enemy_type == "specter":
		update_specter_enemies()

func update_specter_enemies():
	var specter_remaining = 0
	for child in $Entities.get_children():
		if child is SpecterEnemy:
			specter_remaining += 1
	if specter_remaining < 2:
		return
	
	var i = 0
	
	for child in $Entities.get_children():
		if child is SpecterEnemy:
			child.movement_rotation = 2 * PI / specter_remaining * i
			i += 1


func _on_TestTimer_timeout():
	create_wave(battle_waves[randi()%battle_waves.size()])
