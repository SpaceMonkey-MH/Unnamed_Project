class_name DesertEagleState
extends WeaponsState

@export var reload_timer: Timer
@export var bullet_1_scene: PackedScene
@export var next_weapon_state: ShotgunState
@export var previous_weapon_state: MeleeWeaponState
@export var attack_damage: float = 20
@export var speed_factor: float = 10
@export var reload_time: float = 0.8
@onready var reload_bar = get_parent().reload_bar


func _ready() -> void:
	reload_timer.wait_time = reload_time


func state_process(delta) -> void:
	# Moved it in state input becasue it is better suited for this purpose.
	#if Input.is_action_just_pressed("fire") and can_fire:
		#weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_1_scene,
		#attack_damage, speed_factor)
		#can_fire = false
		#timer.start()
	if not can_fire:
		reload_bar.update_value(-delta * 1000)


func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	if event.is_action_pressed("fire") and can_fire:
		weapon_fire(character.position, character.get_global_mouse_position(), bullet_1_scene,
			attack_damage, speed_factor)
		can_fire = false
		reload_timer.start()


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	reload_timer.paused = false
	#print("reload_time in d_e_s.gd: ", reload_time)
	# We multiply everything by 1000 so that it handles better the floats. The ratios sould stay the same.
	reload_bar.set_max_value(reload_time * 1000)
	#reload_bar.set_max_value(1000)
	if reload_timer.time_left != 0:
		reload_bar.update_value(-reload_time * 1000)
	reload_bar.update_value(reload_timer.time_left * 1000)


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	reload_timer.paused = true


#func weapon_fire(spawn_pos: Vector2, target_pos: Vector2):
#	var bullet = bullet_1_scene.instantiate()
#	var rotation = spawn_pos.angle_to_point(target_pos)
##	print(rotation)
#	bullet.position = spawn_pos
#	bullet.rotate(rotation)
#	bullet.direction = target_pos - spawn_pos
#	add_child(bullet)


func _on_desert_eagle_cool_down_timeout() -> void:
	can_fire = true
	reload_bar.update_value(reload_time * 1000)
