extends Node

class_name CharacterMovementStateMachine

@export var player : CharacterBody2D
@export var animatioon_tree : AnimationTree
@export var current_state : MovementState

var states : Array[MovementState]



# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if (child is MovementState):
			states.append(child)
			
			# Set the states up with what they need to function
			child.player = player
			child.playback = animatioon_tree["parameters/playback"]
#			print(child)
			child.move_speed= player.move_speed
#			print(child.move_speed)
			child.air_jumps_max = player.air_jumps_max
#			print(child.air_jumps_max)
			child.air_jumps_current = child.air_jumps_max
#			print(child.air_jumps_current)
			child.jump_height = player.jump_height
#			print(child.jump_height)
			child.jump_time_to_peak = player.jump_time_to_peak
#			print(child.jump_time_to_peak)
			child.jump_time_to_descent = player.jump_time_to_descent
#			print(child.jump_time_to_descent)
			child.jump_velocity = ((2.0 * child.jump_height) / child.jump_time_to_peak) * -1.0
			child.jump_gravity = ((-2.0 * child.jump_height) / (child.jump_time_to_peak * child.jump_time_to_peak)) * -1.0
			child.fall_gravity = ((-2.0 * child.jump_height) / (child.jump_time_to_descent * child.jump_time_to_descent)) * -1.0


		else:
			push_warning("Child " + child.name + " is not a MovementState for CharacterStateMachine.")


func _physics_process(delta):
	if(current_state.next_state != null):
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)

# Used for the landing animation (the player can't move during this), this isn't very useful here.
func check_if_can_move():
	return current_state.can_move


func switch_states(new_state : MovementState):
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	current_state.on_enter()


func _input(event : InputEvent):
	current_state.state_input(event)
