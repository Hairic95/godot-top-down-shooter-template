extends Node

signal change_scene(new_scene)

signal create_bullet(bullet_instance, start_pos, rotation)
signal create_effect(effect_instance, start_pos)

signal player_health_update(current_hit_points, max_hit_points)

signal enemy_death(enemy_type)
signal player_death()

