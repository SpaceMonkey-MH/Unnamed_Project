class_name MachineGunState
extends WeaponsState

@export var timer : Timer
@export var next_weapon_state : GrenadeLauncherState
@export var previous_weapon_state : FireSpitterState
@export var bullet_2_scene : PackedScene
@export var attack_damage : float = 10
@export var speed_factor : float = 12
@export var reload_time : float = 0.2


func _ready() -> void:
	timer.wait_time = reload_time


#func state_process(_delta) -> void:
	#if Input.is_action_pressed("fire") and can_fire:
		#weapon_fire(character.position, character.get_global_mouse_position(), bullet_2_scene,
		#attack_damage, speed_factor)
		#can_fire = false
		#timer.start()
		#print("mg.gd: ", get_parent().get_parent(), "\n", character)
		#pass


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	# This does not work here, event is only the new ones, not continuous.
	#if Input.is_action_pressed("fire") and can_fire:
		#print("Fired in state_input() in weapon2.gd.")
		#weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_2_scene,
		#attack_damage, speed_factor)
		#can_fire = false
		#timer.start()
	if event.is_action_pressed("fire") and can_fire:
		weapon_fire(character.position, character.get_global_mouse_position(), bullet_2_scene,
		attack_damage, speed_factor)
		can_fire = false
		timer.start()


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	timer.paused = false


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	timer.paused = true


func _on_machine_gun_cool_down_timeout() -> void:
	can_fire = true
#	print("hello2")

