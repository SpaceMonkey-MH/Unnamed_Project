extends MovementState

class_name LandingState

@export var landing_animation_name : String = "landing"
@export var jump_animation_name : String = "jump_start"
@export var idle_state : IdleState
@export var air_state : AirState


func _on_animation_tree_animation_finished(anim_name):
	if (anim_name == landing_animation_name):
		next_state = idle_state



func state_input(event : InputEvent):
	if event.is_action_pressed("jump"):
		jump()


func jump():
	character.velocity.y = jump_velocity
	next_state = air_state
	playback.travel(jump_animation_name)
