extends Area2D
class_name PlayerBulletMelee

var enemies = []

export (int) var damage = 1
export (float) var push_force = 80

var direction = Vector2.ZERO

func _ready():
	$Anim.play("Bullet")

func _on_Anim_animation_finished(anim_name):
	queue_free()

func _on_MeleeBullet_area_entered(area):
	pass # Replace with function body.
