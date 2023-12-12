extends State

class_name WeaponsState

var can_fire : bool = true

# Base funstion for the weapon firing mechanic.
func weapon_fire(spawn_pos : Vector2, target_pos : Vector2, bullet_scene : PackedScene):
	var bullet = bullet_scene.instantiate()
	var rotation = spawn_pos.angle_to_point(target_pos)
	bullet.position = spawn_pos
	bullet.rotate(rotation)
	bullet.direction = target_pos - spawn_pos
	add_child(bullet)

