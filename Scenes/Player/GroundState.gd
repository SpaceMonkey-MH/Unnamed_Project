extends State

class_name GroundState



@export var air_state : State



func _ready():
	jump_height = 1




func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()


func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
