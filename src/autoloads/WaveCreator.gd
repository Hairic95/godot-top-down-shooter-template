extends Node

onready var specter_enemy_reference = load("res://src/entities/enemies/SpecterEnemy.tscn")
onready var eyeball_enemy_reference = load("res://src/entities/enemies/EyeballEnemy.tscn")

onready var available_waves = {
	"wave_eyeball_01": [
		{
			"reference": eyeball_enemy_reference,
			"quantity": 4
		}
	],
	"wave_specter_01": [
		{
			"reference": specter_enemy_reference,
			"quantity": 4
		}
	],
	"wave_specter_02": [
		{
			"reference": specter_enemy_reference,
			"quantity": 6
		}
	],
	"wave_specter_03": [
		{
			"reference": specter_enemy_reference,
			"quantity": 8
		}
	],
	"wave_mixed_01": [
		{
			"reference": eyeball_enemy_reference,
			"quantity": 4
		},
		{
			"reference": specter_enemy_reference,
			"quantity": 4
		}
	],
}

func get_wave(wave_code):
	if available_waves.has(wave_code):
		return available_waves[wave_code]
