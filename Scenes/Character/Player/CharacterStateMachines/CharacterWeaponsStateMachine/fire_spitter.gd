class_name FireSpitterState
extends WeaponsState

@export var fire_spitter_weapon : Area2D
@export var next_weapon_state : MachineGunState
@export var previous_weapon_state : RocketLauncherState
@export var timer : Timer
@export var attack_damage : float = 50.0
@export var reload_time : float = 0.5

# A variable to store whether or not the fire button is pressed. This is used to go around the fact that
# _unhandled_input() doesn't do continuous input (click hold is just a click).
var fire_pressed : bool = false


func _ready():
	timer.wait_time = reload_time
	fire_spitter_weapon.monitoring = false


func state_process(_delta) -> void:
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
	if event.is_action_released("fire"):
		fire_pressed = false

