extends Sprite

var depleted = false

func _ready():
	restore()

func restore():
	$Anim.stop()
	frame = 0
	depleted = false

func deplete():
	if !depleted:
		$Anim.play("Depleted")
		depleted = true

func show_depleted():
	frame = hframes - 1
	depleted = true
