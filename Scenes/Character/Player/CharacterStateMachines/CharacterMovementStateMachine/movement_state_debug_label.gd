extends Label


@export var state_machine : CharacterMovementStateMachine


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "Movement State: " + state_machine.current_state.name
