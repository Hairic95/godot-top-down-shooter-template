extends KinematicBody2D
class_name Player

const SPEED = 100
var dash_speed = 230

var active = true

# todo add pushbox physic
var pushboxes = []

var latest_direction = Vector2.DOWN
var movement_direction = Vector2.ZERO
var shooting_direction = Vector2.DOWN
var dash_direction = Vector2.DOWN

var is_melee_reloading : bool = false
var is_reloading : bool = false

var dash_timer = .02
var dash_timer_value = 0

export (PackedScene) var bullet_reference
export (PackedScene) var melee_reference
export (PackedScene) var dash_effect

var current_state = "Idle"

signal create_bullet(bullet_instance, start_direction, direction)

func _ready():
	randomize()

func _process(delta):
	movement_direction = Vector2.ZERO
	shooting_direction = Vector2.ZERO
	
	if active and current_state != "Dash":
			
		if Input.is_key_pressed(KEY_W):
			movement_direction.y = -1
			latest_direction = Vector2.UP
		if Input.is_key_pressed(KEY_S):
			movement_direction.y = 1
			latest_direction = Vector2.DOWN
		if Input.is_key_pressed(KEY_A):
			movement_direction.x = -1
			latest_direction = Vector2.LEFT
			$Sprite.flip_h = false
		if Input.is_key_pressed(KEY_D):
			movement_direction.x = 1
			latest_direction = Vector2.RIGHT
			$Sprite.flip_h = true
		
		
		if Input.is_key_pressed(KEY_W) || Input.is_key_pressed(KEY_S) || Input.is_key_pressed(KEY_A) || Input.is_key_pressed(KEY_D):
			set_state("Move")
		else:
			set_state("Idle")
		
		if Input.is_key_pressed(KEY_UP):
			shooting_direction.y = -1
		if Input.is_key_pressed(KEY_DOWN):
			shooting_direction.y = 1
		if Input.is_key_pressed(KEY_RIGHT):
			shooting_direction.x = 1
		if Input.is_key_pressed(KEY_LEFT):
			shooting_direction.x = -1
		if Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_DOWN) || Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_LEFT):
			if !is_reloading && !Input.is_key_pressed(KEY_SHIFT):
				is_reloading = true
				shoot()
			if !is_melee_reloading && Input.is_key_pressed(KEY_SHIFT):
				is_melee_reloading = true
				swing_melee()
		if Input.is_action_just_pressed("dash"):
			dash()
	elif current_state == "Dash":
		# create dash effect
		if dash_timer_value >= dash_timer:
			dash_timer_value = 0
			if dash_effect != null:
				var dash_effect_instance = dash_effect.instance()
				dash_effect_instance.flip_h = $Sprite.flip_h
				EventBus.emit_signal("create_effect", dash_effect_instance, global_position)
		else:
			dash_timer_value += delta
		# moves and check wall collision
		var collider = move_and_collide(dash_direction.normalized() * dash_speed * delta)
		if collider:
			$Timers/DashTimer.stop()
			set_state("Idle")
	
	var push_force = Vector2.ZERO
	for pushbox in pushboxes:
		push_force += (global_position - pushbox.global_position).normalized() * 10
	
	move_and_slide(movement_direction.normalized() * SPEED + push_force)
	
	set_gun_sprite()

func set_state(new_state):
	if new_state != current_state:
		current_state = new_state
		$Anim.play(new_state)

func set_gun_sprite():
	match (shooting_direction):
		Vector2.DOWN:
			$Gun.frame = 0
		Vector2.UP:
			$Gun.frame = 1
		Vector2.RIGHT:
			$Gun.frame = 2
		Vector2.LEFT:
			$Gun.frame = 3
		Vector2.RIGHT + Vector2.UP:
			$Gun.frame = 4
		Vector2.RIGHT + Vector2.DOWN:
			$Gun.frame = 5
		Vector2.LEFT + Vector2.DOWN:
			$Gun.frame = 6
		Vector2.LEFT + Vector2.UP:
			$Gun.frame = 7

func shoot():
	if bullet_reference != null:
		EventBus.emit_signal("create_bullet", bullet_reference.instance(), global_position + shooting_direction.normalized() * 6, shooting_direction.normalized())
	$Sounds/ShootSound.pitch_scale = 0.4 + randf()
	$Sounds/ShootSound.play()
	$Timers/ReloadTimer.start()

func swing_melee():
	if melee_reference != null:
		var melee_instance = melee_reference.instance()
		melee_instance.rotation = shooting_direction.angle()
		$MeleeBullets.add_child(melee_instance)
	$Sounds/ShootSound.pitch_scale = 0.4 + randf()
	$Sounds/ShootSound.play()
	$Timers/ReloadMeleeTimer.start()

func dash():
	set_state("Dash")
	if movement_direction == Vector2.ZERO:
		dash_direction = latest_direction
	else:
		dash_direction = movement_direction
	$Sounds/DashSound.pitch_scale = 1 + randf() / 3.3
	$Sounds/DashSound.play()
	$Timers/DashTimer.start()

func _on_ReloadTimer_timeout():
	is_reloading = false

func _on_ReloadMeleeTimer_timeout():
	is_melee_reloading = false

func _on_DashTimer_timeout():
	set_state("Idle")
