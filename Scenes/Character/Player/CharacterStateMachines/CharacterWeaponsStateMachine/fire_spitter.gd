class_name FireSpitterState
extends WeaponsState

@export var fire_spitter_weapon : Area2D
@export var next_weapon_state : MachineGunState
@export var previous_weapon_state : RocketLauncherState
@export var timer : Timer
@export var attack_damage : float = 50.0
@export var reload_time : float = 0.5


func _ready():
	timer.wait_time = reload_time


func state_process(_delta) -> void:
	if Input.is_action_pressed("fire") and can_fire:
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

