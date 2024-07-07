class_name FollowState
extends EnemyState

# The distance beyond which the enemy stops following the player.
@export var follow_stop_distance : float = 400.0
# The Wander state as a variable, so that it can be transitionned to.
@export var wander_state : EnemyState
# The direction of the movement of the enemy, -1, 0 or 1. Set using the relative position of the player.
var follow_direction : int = 0
# The margin for the direction of the follow (so that the character doesn't act crazy when directly under or over
# the player).
var follow_margin : float = 10.0


func state_process(_delta):
#	print("Hello!")
	# Moving the character in the follow_direction, at the follow speed.
	# We use the move_speed variable directly, as it is the way the Creator (I) intended it.
	character.velocity.x = follow_direction * move_speed
	# Using an auxilliary variable to compute the direction and the distance.
	var aux_variable = player.position.x - character.position.x
	# Now we need to assign the correct value to follow_direction.
	# If the player is farther (with a small margin) on x axis than the character.
	if aux_variable > follow_margin:
		# follow_direction is positive (so, 1).
		follow_direction = 1
	# If the player is less far (with a small margin) on x axis than the character.
	elif aux_variable < -follow_margin:
		# follow_direction is negative (so, -1).
		follow_direction = -1
	# If the player is as far (with a small margin) on x axis as the character.
	else:
		# follow_direction is zero (so, 0).
		follow_direction = 0
	# If the character is too far from the player (farther than follow_stop_distance). >= because why not.
#	print(aux_variable)
	if abs(aux_variable) >= follow_stop_distance:
		next_state = wander_state
	
