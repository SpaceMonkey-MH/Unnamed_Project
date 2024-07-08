class_name AirState
extends MovementState

@export var landing_state : LandingState
@export var air_jump_animation_name : String = "air_jump"
@export var air_animation_name : String = "air"
@export var landing_animation_name : String = "landing"


func _process(_delta) -> void:
#	print("is_on_floor : ", character.is_on_floor(), "\n next state : ", next_state)
#	print(air_jumps_current)
	pass

func state_process(_delta) -> void:
	if character.is_on_floor():
		next_state = landing_state

func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("jump") && air_jumps_current > 0:
		air_jump()

func on_exit() -> void:
	if next_state is LandingState:
		air_jumps_current = air_jumps_max
		playback.travel(landing_animation_name)	# Maybe this should go in state_process instead.


func air_jump() -> void:
	air_jumps_current -= 1
	character.velocity.y = jump_velocity
	# Using the start() method because apparently it allows
	# to jump directly to the animation, thus allowing to replay the animation before it ends.
	playback.start(air_jump_animation_name)





func _on_animation_tree_animation_finished(anim_name) -> void:
	if (anim_name == air_jump_animation_name):
		playback.travel(air_animation_name)
#		print("hello")
		
