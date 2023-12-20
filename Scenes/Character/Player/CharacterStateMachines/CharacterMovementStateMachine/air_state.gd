extends MovementState

class_name AirState

@export var landing_state : LandingState
@export var air_jump_animation_name : String = "air_jump"
@export var air_animation_name : String = "air"
@export var landing_animation_name : String = "landing"


func _process(delta):
#	print("is_on_floor : ", character.is_on_floor(), "\n next state : ", next_state)
#	print(air_jumps_current)
	pass

func state_process(delta):
	if character.is_on_floor():
		next_state = landing_state

func state_input(event : InputEvent):
	if event.is_action_pressed("jump") && air_jumps_current > 0:
		pass
		air_jump()

func on_exit():
	if next_state is LandingState:
		air_jumps_current = air_jumps_max
		playback.travel(landing_animation_name)	# Maybe this should go in state_process instead.


func air_jump():
	air_jumps_current -= 1
	character.velocity.y = jump_velocity
	playback.travel(air_jump_animation_name)





func _on_animation_tree_animation_finished(anim_name):
	if (anim_name == air_jump_animation_name):
		playback.travel(air_animation_name)
#		print("hello")
		
