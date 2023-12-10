extends WeaponsState

class_name EmptyState

@export var next_weapon_state : Weapon1
@export var previous_weapon_state : Weapon8


func state_process(delta):
	if Input.is_action_just_pressed("fire"):
		print("fire")	# Will print once per click.
	if Input.is_action_pressed("fire"):
		print("firing")	# Will print continuesly during the hold.

func state_input(event : InputEvent):
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
#	if event.is_action_pressed("fire"):	# Not working as intended, too many or too few "fire".
#		print("fire")

#	print("empty: ", next_state)
