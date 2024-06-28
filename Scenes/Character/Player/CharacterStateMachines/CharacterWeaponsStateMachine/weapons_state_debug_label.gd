extends Label


@export var state_machine : CharacterWeaponsStateMachine


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "Weapons State: " + state_machine.current_state.name
