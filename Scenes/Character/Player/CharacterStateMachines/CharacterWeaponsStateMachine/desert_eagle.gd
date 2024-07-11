extends WeaponsState

class_name DesertEagleState

@export var timer : Timer
@export var bullet_1_scene : PackedScene
@export var next_weapon_state : Weapon2
@export var previous_weapon_state : MeleeWeaponState
@export var attack_damage : float = 20
@export var speed_factor : float = 10

var wait_time : float = 0.8

func _ready():
	timer.wait_time = wait_time

func state_process(_delta):
	if Input.is_action_just_pressed("fire") and can_fire:
		weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_1_scene,
		attack_damage, speed_factor)
		can_fire = false
		timer.start()

func state_input(event : InputEvent):
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state

#
#func weapon_fire(spawn_pos : Vector2, target_pos : Vector2):
#	var bullet = bullet_1_scene.instantiate()
#	var rotation = spawn_pos.angle_to_point(target_pos)
##	print(rotation)
#	bullet.position = spawn_pos
#	bullet.rotate(rotation)
#	bullet.direction = target_pos - spawn_pos
#	add_child(bullet)


func _on_weapon_1_cool_down_timeout():
	can_fire = true
