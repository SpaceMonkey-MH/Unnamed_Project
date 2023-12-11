extends WeaponsState

class_name Weapon1

@export var bullet_1_scene : PackedScene
@export var next_weapon_state : Weapon2
@export var previous_weapon_state : EmptyState


func state_process(delta):
	if Input.is_action_just_pressed("fire"):
		weapon_fire(get_parent().get_parent().position, player.get_global_mouse_position())

func state_input(event : InputEvent):
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state


func weapon_fire(spawn_pos : Vector2, target_pos : Vector2):
	var bullet = bullet_1_scene.instantiate()
	var rotation = spawn_pos.angle_to_point(target_pos)
	print(rotation)
	bullet.position = spawn_pos
	bullet.rotate(rotation)
	bullet.direction = target_pos - spawn_pos
	add_child(bullet)
