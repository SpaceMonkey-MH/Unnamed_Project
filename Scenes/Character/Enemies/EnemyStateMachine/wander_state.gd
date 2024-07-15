class_name WanderState
extends EnemyState

# The Follow state as a variable, so it can be put in next_state.
@export var follow_state : FollowState
# The Attack state as a variable, so it can be put in next_state.
@export var attack_state : AttackState
# The direction of movement of the character: -1 left, 0 idle, 1 right. To be randomized.
var wander_direction : int = 0
# Time during which the enemy wanders in that direction. To be randomized.
var wander_time : float = 0.0
# The speed at which the enemy wanders. To be randomized.
var wander_speed : float = 0.0
# move_speed is the variable of the speed of the character, from the character code (superclass, actually).
# Scratch that, this is shit.
## The speed at which the enemy will wander.
#@export var wander_move_speed : float = 50.0


# Called in _physics_process in state machine. 
func state_process(delta) -> void:
	# Move the enemy.
	character.velocity.x = wander_direction * wander_speed
	# Reduce the time of wandering remaining by the time elapsed since the last call (delta).
	wander_time -= delta
	# If the wander time is 0 or less, randomize the wander values again. 
	if wander_time <= 0:
		randomize_variables()
#	print(direction, "\n", move_speed, "\n")
#	print(player.position.x)
	# Using an auxilliary variable to compute the distance to player.
	var relative_x_distance_to_player = player.position.x - character.position.x
	# If the enemy is closer than the fixed distance to the player. Setting to <= because idk.
	if abs(relative_x_distance_to_player) <= follow_distance:
		next_state = follow_state
	elif abs(relative_x_distance_to_player) <= attack_range:
		next_state = attack_state


# Procedure that randomizes the values of wander_direction, wander_time and wander_speed, so that the wander
# movement is more random and thus less predictable (?).
func randomize_variables() -> void:
	# Randomizing the wander direction to -1, 0 or 1.
	wander_direction = randi_range(-1, 1)
	# Randomizing the wander time to a range from 0 to max_wander_time.
	wander_time = randf_range(0, max_wander_time)
	# Randomizing the wander speed to a range from move_speed/4 to move_speed/2, this low 
	# because move_speed is the follow speed.
	wander_speed = randf_range(move_speed / 4, move_speed / 2)
#	print(wander_direction, " ", wander_time, " ", wander_speed)


#func wander() -> void:
#	# I don't know how to print correctly xd.
#	print(direction, "\n", move_speed, "\n\n")
##	print_rich("Hello from wander() in WanderState.\nDirection: %d.\nMove speed: %f.", direction, move_speed)
#	character.velocity.x = direction * move_speed
##	print("character: ", character)
