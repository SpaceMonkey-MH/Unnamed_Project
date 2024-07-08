extends Node

class_name CharacterMovementStateMachine

@export var character : CharacterClass
@export var animation_tree : AnimationTree
@export var current_state : State

var states : Array[State]



# Called when the node enters the scene tree for the first time.
func _ready():
#	print("CharacterMovementStateMachine is ready.")
#	print(get_parent())
#	print(animation_tree)
	for child in get_children():
		if (child is State):
			states.append(child)
#			print(states)
			
			# Set the states up with what they need to function.
			child.character = character
			child.move_speed= character.move_speed
#			print(child.move_speed, " ", self, "\n", child)
#			print("1 ", character.move_speed)
#			print("character: ", character)
#			print(child.move_speed)
			if character is PlayerClass:
				child.playback = animation_tree["parameters/playback"]
	#			print(child)
				child.air_jumps_max = character.air_jumps_max
	#			print(child.air_jumps_max)
				child.air_jumps_current = child.air_jumps_max
	#			print(child.air_jumps_current)
				child.jump_height = character.jump_height
	#			print(child.jump_height)
				child.jump_time_to_peak = character.jump_time_to_peak
	#			print(child.jump_time_to_peak)
				child.jump_time_to_descent = character.jump_time_to_descent
	#			print(child.jump_time_to_descent)
				child.jump_velocity = ((2.0 * child.jump_height) /
				child.jump_time_to_peak) * -1.0
				child.jump_gravity = ((-2.0 * child.jump_height) /
				(child.jump_time_to_peak * child.jump_time_to_peak)) * -1.0
				child.fall_gravity = ((-2.0 * child.jump_height) /
				(child.jump_time_to_descent * child.jump_time_to_descent)) * -1.0
			# If the character the state machine is for is an enemy.
			if character is EnemyClass:
				# Assign the player value of the states to the player value of the character,
				# which should be the Player.
				child.player = character.player
#				print(child.player)
				# Assign the follow_distance value of the states to the follow_distance value of the character.
				child.follow_distance = character.follow_distance
				# Assign the follow_stop_distance value of the states to the follow_stop_distance
				# value of the character.
				child.follow_stop_distance = character.follow_stop_distance
				# Assign the attack_distance value of the states to the attack_distance value of the character.
				child.attack_distance = character.attack_distance
				# Assign the max_wander_time value of the states to the max_wander_time value of the character.
				child.max_wander_time = character.max_wander_time
				
#			if character is # ?
				
			# Connect to interrupt signal. I d'ont know what interrupt signal does.
			child.connect("interrupt_state", on_state_interrupt_state)
#			print(child)
#			print(states)
#			print(child.is_connected("interrupt_state", on_state_interrupt_state))	# Prints false.
#			Hum... All good now.


		else:
			push_warning("Child " + child.name + " is not a State for CharacterStateMachine.")


func _physics_process(delta):
	if(current_state.next_state != null):
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)
	# This should be outdated.
#	# This is ugly, but I don't know how to do it better.
#	if not character is Player and current_state is WanderState:
##		print("current_state is: ", current_state)
#		current_state.wander(character)
		

# Used for the landing animation (the player can't move during this), this isn't very useful here.
func check_if_can_move():
	return current_state.can_move


func switch_states(new_state : State):
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	current_state.on_enter()


func _input(event : InputEvent):
	current_state.state_input(event)

# Used to switch to state Hit.
func on_state_interrupt_state(new_state : State):
#	print("hello")
	switch_states(new_state)
