class_name FireSpitterState
extends WeaponsState

# The code here is a mix between the code from melee_weapon_state.gd and machine_gun_state.gd, so there will be
# little explanation here.

@export var fire_spitter_weapon : Area2D
@export var next_weapon_state : MachineGunState
@export var previous_weapon_state : RocketLauncherState
@export var timer : Timer
@export var attack_damage : float = 20.0
# I think the minimum effective cool down is 0.05, lower is useless as there is an await call in state_process()
# that I don't think can be much lower.
@export var reload_time : float = 0.2
@export var fire_duration : float = 5.0
@export var fire_damage : float = 10.0

# A variable to store whether or not the fire button is pressed. This is used to go around the fact that
# _unhandled_input() doesn't do continuous input (click hold is just a click).
var fire_pressed : bool = false


func _ready():
	timer.wait_time = reload_time
	fire_spitter_weapon.monitoring = false


func state_process(_delta) -> void:
	#print("fire_pressed in fire_spitter_state.gd: ", fire_pressed, "\ncan_fire: ", can_fire)
	if fire_pressed and can_fire:
		fire_spitter_weapon.monitoring = true
		can_fire = false
		timer.start()
		await get_tree().create_timer(0.05).timeout
		fire_spitter_weapon.monitoring = false


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	if event.is_action_pressed("fire"):
		fire_pressed = true
		fire_spitter_weapon.toggle_visible()
	if event.is_action_released("fire"):
		fire_pressed = false
		fire_spitter_weapon.toggle_visible()


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	timer.paused = false


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	timer.paused = true



func _on_fire_spitter_cool_down_timeout():
	can_fire = true
