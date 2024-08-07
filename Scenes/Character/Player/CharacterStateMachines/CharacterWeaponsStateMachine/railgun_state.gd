class_name RailgunState
extends WeaponsState

@export var next_weapon_state : MeleeWeaponState
@export var previous_weapon_state : FlameThrowerState
@export var timer : Timer
@export var railgun_projectile_scene : PackedScene
@export var attack_damage : float = 200
# WARNING: this should not be too high, otherwise the projectile doesn't have the time to damage the enemies.
@export var speed_factor : float = 50
@export var reload_time : float = 10


func _ready() -> void:
	timer.wait_time = reload_time


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	if event.is_action_pressed("fire") and can_fire:
		weapon_fire(character.position, character.get_global_mouse_position(), railgun_projectile_scene,
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


func _on_railgun_cool_down_timeout() -> void:
	can_fire = true

