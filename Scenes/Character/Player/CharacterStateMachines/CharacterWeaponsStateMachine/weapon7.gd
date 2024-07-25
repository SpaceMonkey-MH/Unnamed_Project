class_name FlameThrowerState
extends WeaponsState

@export var next_weapon_state : RailgunState
@export var previous_weapon_state : GrenadeLauncherState


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state

