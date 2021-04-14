extends Node2D

export (int) var min_rooms = 24
export (int) var max_rooms = 32

export (int) var max_room_per_branch = 10

func _ready():
	randomize()
	generate_level()

func generate_level():
	
	var cells = [Vector2.ZERO]
	
	while cells.size() < min_rooms:
		
		var walker = Vector2.ZERO
		
		for i in max_room_per_branch:
			if cells.size() == max_rooms:
				break
			match(randi()%4):
				0:
					walker += Vector2.UP
				1:
					walker += Vector2.DOWN
				2:
					walker += Vector2.RIGHT
				3:
					walker += Vector2.LEFT
			if !cells.has(walker):
				cells.append(walker)
		
		if cells.size() == max_rooms:
			break
	
	for cell in cells:
		var new_room = Sprite.new()
		new_room.texture = preload("res://assets/textures/battle/arena.png")
		new_room.global_position = cell * Vector2(200, 200)
		$Rooms.add_child(new_room)
	
