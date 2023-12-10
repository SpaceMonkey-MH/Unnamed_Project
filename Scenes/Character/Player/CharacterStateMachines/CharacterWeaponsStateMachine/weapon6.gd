extends WeaponsState

class_name Weapon6


@export var next_weapon_state : Weapon7
@export var previous_weapon_state : Weapon5

func state_input(event : InputEvent):
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
