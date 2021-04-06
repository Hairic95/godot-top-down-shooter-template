extends KinematicBody2D
class_name Enemy

export (int) var speed = 50

var max_hit_points = 3
var hit_points = 3

var player

var state = "Chasing"

var movement_direction = Vector2.ZERO

var chase_update_value = 0
var chase_update_timer = .2

var bullet_push = Vector2.ZERO

export (PackedScene) var death_effect

func _ready():
	$Anim.play("Move")

func _process(delta):
	
	match (state):
		"Chasing":
			if player != null:
				if (player.global_position - global_position).length() > 20:
					if chase_update_value >= chase_update_timer:
						chase_update_value = 0
						movement_direction = lerp(movement_direction, (player.global_position - global_position).normalized(), 1).normalized()
				else:
					movement_direction = Vector2.ZERO
					attack()
			chase_update_value += delta
	var push_force = Vector2.ZERO

	push_force += bullet_push
	
	bullet_push *= .96
	if bullet_push.length() <= 2:
		bullet_push = Vector2.ZERO
	
	if movement_direction.x < 0:
		$Sprite.flip_h = false
	elif movement_direction.x > 0:
		$Sprite.flip_h = true
	
	move_and_slide(movement_direction * speed + push_force)

func hurt(damage, push_force, push_direction):
	bullet_push = push_direction * push_force
	hit_points = max(0, hit_points - damage)
	if hit_points == 0:
		if death_effect != null:
			EventBus.emit_signal("create_effect", death_effect.instance(), global_position)
		queue_free()

func attack():
	state = "Attack"
	$Anim.play("Attack")


func _on_Anim_animation_finished(anim_name):
	if anim_name == "Attack":
		state = "Chasing"
		$Anim.play("Move")
