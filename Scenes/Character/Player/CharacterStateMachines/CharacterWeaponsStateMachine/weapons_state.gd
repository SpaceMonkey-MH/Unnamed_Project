class_name WeaponsState
extends State

var can_fire : bool = true


# Base procedure for the weapon firing mechanic.
func weapon_fire(spawn_pos : Vector2, target_pos : Vector2, bullet_scene : PackedScene,
				attack_damage : float, speed_factor : float, aoe_attack_damage : float = 0.0,
				aoe_size : float = 80.0) -> void:
	var bullet = bullet_scene.instantiate()
	var rotation = spawn_pos.angle_to_point(target_pos)
	bullet.position = spawn_pos
	bullet.rotate(rotation)
	bullet.direction = target_pos - spawn_pos
	bullet.attack_damage = attack_damage * character.damage_multiplier
#	print(aoe_attack_damage)
	bullet.aoe_attack_damage = aoe_attack_damage * character.damage_multiplier
	bullet.speed_factor = speed_factor
	bullet.aoe_size = aoe_size
	add_child(bullet)
	#print("Hello from weapon_fire in weapon_state.gd.")
