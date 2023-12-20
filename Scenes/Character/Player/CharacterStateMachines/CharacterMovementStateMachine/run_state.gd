extends MovementState

class_name RunState



@export var air_state : AirState
@export var idle_state : IdleState
@export var jump_animation_name : String = "jump_start"
@export var idle_animation_name : String = "idle"
@export var air_animation_name : String = "air"



func state_process(delta):
	if character.velocity.x == 0:
		next_state = idle_state
		playback.travel(idle_animation_name)
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
