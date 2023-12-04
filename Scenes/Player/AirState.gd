extends State

class_name AirState

@export var ground_state : GroundState

func _process(delta):
#	print("is_on_floor : ", character.is_on_floor(), "\n next state : ", next_state)
#	print(air_jumps_current)
	pass

func state_process(delta):
	if(character.is_on_floor()):
		next_state = ground_state

func state_input(event : InputEvent):
	if(event.is_action_pressed("jump") && air_jumps_current > 0):
		air_jump()

func on_exit():
	if(next_state is GroundState):
		air_jumps_current = air_jumps_max


func air_jump():
	air_jumps_current -= 1
	character.velocity.y = jump_velocity

