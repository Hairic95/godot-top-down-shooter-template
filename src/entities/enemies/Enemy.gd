extends KinematicBody2D
class_name Enemy

export (String) var enemy_type = "enemy"

export (int) var speed = 50
export (int) var damage = 1

var max_hit_points = 3
var hit_points = 3

var player

var state = "Move"

var movement_direction = Vector2.ZERO

var bullet_push = Vector2.ZERO

var arena_borders = Rect2(0, 0, 100, 100)

var latest_player_position = Vector2.ZERO

export (PackedScene) var death_effect

func _ready():
	$Anim.play("Move")

func _process(delta):
	operate_ai(delta)
	
	if movement_direction.x < 0:
		$Sprite.flip_h = false
	elif movement_direction.x > 0:
		$Sprite.flip_h = true
	
	move_enemy(delta)

func hurt(damage, push_force, push_direction):
	bullet_push = push_direction * push_force
	hit_points = max(0, hit_points - damage)
	if hit_points == 0:
		if death_effect != null:
			EventBus.emit_signal("create_effect", death_effect.instance(), global_position)
		EventBus.emit_signal("enemy_death", global_position, enemy_type)
		queue_free()

func operate_ai(delta):
	pass

func move_enemy(delta):
	pass

func set_state(new_state):
	if state != new_state:
		state = new_state
		if $Anim.has_animation(new_state):
			$Anim.play(new_state)

func _on_Anim_animation_finished(anim_name):
	pass

func _on_Hitbox_area_entered(area):
	if area is PlayerBullet || area is PlayerBulletMelee:
		hurt(1, (global_position - area.global_position).normalized(), area.push_force)

func _on_HurtBox_body_entered(body):
	if body is Player:
		body.hurt(damage)

func set_hurtbox_disabled(value):
	$HurtBox/CollisionShape2D.disabled = value
