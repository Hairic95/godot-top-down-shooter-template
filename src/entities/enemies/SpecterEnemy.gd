extends Enemy
class_name SpecterEnemy

export (int) var charge_speed = 120

export (int) var distance_to_player = 50

var destination = Vector2.ZERO
export (float) var movement_rotation = 0
var charge_destination = Vector2.ZERO

func operate_ai(delta):
	match (state):
		"Move":
			movement_rotation += delta
			if movement_rotation >= 2 * PI:
				movement_rotation -= 2 * PI
			if player != null && weakref(player).get_ref():
				latest_player_position = player.global_position
			destination = latest_player_position + Vector2(cos(movement_rotation), sin(movement_rotation)) * distance_to_player
			if (destination - global_position).length() > 5:
				movement_direction = (destination - global_position).normalized()
			else:
				movement_direction = Vector2.ZERO
		"Charge":
			bullet_push = Vector2.ZERO
			movement_direction = Vector2.ZERO
		"Attack":
			bullet_push = Vector2.ZERO
			if (charge_destination - global_position).length() > 5:
				movement_direction = (charge_destination - global_position).normalized()
			else:
				movement_direction = Vector2.ZERO

func attack():
	$ChargeTimer.start()
	set_state("Charge")

func _on_ChargeTimer_timeout():
	if player != null && weakref(player).get_ref():
		charge_destination = global_position + (player.global_position - global_position) * 2
		charge_destination.x = clamp(charge_destination.x, arena_borders.position.x, arena_borders.position.x + arena_borders.size.x)
		charge_destination.y = clamp(charge_destination.y, arena_borders.position.y, arena_borders.position.y + arena_borders.size.y)
		set_state("Attack")
		set_hurtbox_disabled(false)

func _on_ChargeChoiceTimer_timeout():
	if player != null && weakref(player).get_ref():
		$ChargeChoiceTimer.stop()
		attack()
		$AttackTimer.start()

func _on_AttackTimer_timeout():
	set_hurtbox_disabled(true)
	set_state("Move")
	movement_rotation += PI
	$ChargeChoiceTimer.start()

func move_enemy(delta):
	match(state):
		"Move":
			bullet_push *= .8
			if bullet_push.length() <= 2:
				bullet_push = Vector2.ZERO
			move_and_slide(movement_direction * (speed + (destination - global_position).length()) + bullet_push * 3)
		"Attack":
			move_and_slide(movement_direction * charge_speed + bullet_push * 3)

func reset_timer():
	if state == "Move":
		$ChargeChoiceTimer.stop()
		$ChargeChoiceTimer.start()
