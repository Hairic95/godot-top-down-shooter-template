extends Enemy
class_name EyeballEnemy

var target_direction = Vector2.ZERO
var current_direction = Vector2.ZERO

func _ready():
	pass

func move_enemy(delta):
	if player != null && weakref(player).get_ref():
		target_direction = (player.global_position - global_position).normalized() * speed
		
		current_direction = lerp(current_direction, target_direction, .033)
		move_and_slide(current_direction)
