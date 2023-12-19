extends State

class_name WeaponsState

var can_fire : bool = true

# Base funstion for the weapon firing mechanic.
func weapon_fire(spawn_pos : Vector2, target_pos : Vector2, bullet_scene : PackedScene,
				attack_damage : float, speed_factor : float, aoe_attack_damage : float = 0):
	var bullet = bullet_scene.instantiate()
	var rotation = spawn_pos.angle_to_point(target_pos)
	bullet.position = spawn_pos
	bullet.rotate(rotation)
	bullet.direction = target_pos - spawn_pos
	bullet.attack_damage = attack_damage * player.damage_multiplier
#	print(aoe_attack_damage)
	bullet.aoe_attack_damage = aoe_attack_damage * player.damage_multiplier
	bullet.speed_factor = speed_factor
	add_child(bullet)

