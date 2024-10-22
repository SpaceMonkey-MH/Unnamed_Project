extends MovementState

class_name IdleState


@export var air_state : AirState
@export var run_state : RunState
@export var run_animation_name : String = "run"
@export var jump_animation_name : String = "jump_start"
@export var air_animation_name : String = "air"



func state_process(_delta):
	if character.velocity.x != 0:
		next_state = run_state
		playback.travel(run_animation_name)
	if !character.is_on_floor():
		next_state = air_state
		playback.travel(air_animation_name)


func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()


func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_animation_name)
