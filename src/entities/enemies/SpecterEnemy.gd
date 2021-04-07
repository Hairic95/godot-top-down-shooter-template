extends Enemy
class_name SpecterEnemy

export (int) var charge_speed = 120

export (int) var distance_to_player = 50

var movement_rotation = 0
var charge_destination = Vector2.ZERO

func operate_ai(delta):
	match (state):
		"Move":
			movement_rotation += delta
			if movement_rotation >= 2 * PI:
				movement_rotation -= 2 * PI
			if player != null:
				var destination = player.global_position + Vector2(cos(movement_rotation), sin(movement_rotation)) * distance_to_player
				if (destination - global_position).length() > 5:
					movement_direction = (destination - global_position).normalized()
				else:
					if $ChargeChoiceTimer.paused:
						print("self")
						$ChargeChoiceTimer.start()
					movement_direction = Vector2.ZERO
		"Charge":
			movement_direction = Vector2.ZERO
		"Attack":
			if (charge_destination - global_position).length() > 5:
				movement_direction = (charge_destination - global_position).normalized()
			else:
				movement_direction = Vector2.ZERO

func attack():
	$ChargeTimer.start()
	set_state("Charge")

func _on_ChargeTimer_timeout():
	charge_destination = global_position + (player.global_position - global_position) * 2
	charge_destination.x = clamp(charge_destination.x, arena_borders.position.x, arena_borders.position.x + arena_borders.size.x)
	charge_destination.x = clamp(charge_destination.x, arena_borders.position.y, arena_borders.position.y + arena_borders.size.y)
	set_state("Attack")

func _on_ChargeChoiceTimer_timeout():
	$ChargeChoiceTimer.stop()
	attack()
	$AttackTimer.start()

func _on_AttackTimer_timeout():
	set_state("Move")
	$ChargeChoiceTimer.wait_time = 2.2 + randf() / 2 - .25
	$ChargeChoiceTimer.start()

func move_enemy(delta):
	match(state):
		"Move":
			move_and_slide(movement_direction * speed + bullet_push)
		"Attack":
			move_and_slide(movement_direction * charge_speed + bullet_push)
