extends Area2D

var enemies = []

export (int) var damage = 1
export (float) var push_force = 80

var direction = Vector2.ZERO

func _ready():
	$Anim.play("Bullet")

func _on_Anim_animation_finished(anim_name):
	queue_free()

func _on_MeleeBullet_body_entered(body):
	if body is Enemy:
		if !enemies.has(body):
			enemies.append(body)
			body.hurt(damage, push_force, direction)
