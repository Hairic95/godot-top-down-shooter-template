extends Area2D
class_name PlayerBullet

export (PackedScene) var death_effect

export (int) var damage = 1
export (float) var speed = 280
export (float) var push_force = 80

var direction := Vector2.ZERO

func _ready():
	rotation = direction.angle()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_Bullet_body_entered(body):
	if death_effect != null:
		EventBus.emit_signal("create_effect", death_effect.instance(), global_position)
	queue_free()
