class_name FollowState
extends EnemyState

# The Attack state as a variable, so that it can be transitionned to.
@export var attack_state : AttackState
# The Wander state as a variable, so that it can be transitionned to.
@export var wander_state : WanderState
# The direction of the movement of the enemy, -1, 0 or 1. Set using the relative position of the player.
var follow_direction : int = 0
# The margin for the direction of the follow (so that the character doesn't act crazy when directly under or over
# the player).
var follow_margin : float = 10.0


func state_process(_delta) -> void:
#	var time = Time.get_time_dict_from_system()
#	print("Hello! ", time.second)
	# If the enemy is not knocked back.
	if not character.knocked_back:
		# Moving the character in the follow_direction, at the follow speed.
		# We use the move_speed variable directly, as it is the way the Creator (I) intended it.
		character.velocity.x = follow_direction * move_speed
	# Using an auxilliary variable to compute the direction and the distance to player.
	var relative_x_distance_to_player = player.position.x - character.position.x
	# Now we need to assign the correct value to follow_direction.
	# If the player is farther (with a small margin) on x axis than the character.
	if relative_x_distance_to_player > follow_margin:
		# follow_direction is positive (so, 1).
		follow_direction = 1
	# If the player is less far (with a small margin) on x axis than the character.
	elif relative_x_distance_to_player < -follow_margin:
		# follow_direction is negative (so, -1).
		follow_direction = -1
	# If the player is as far (with a small margin) on x axis as the character.
	else:
		# follow_direction is zero (so, 0).
		follow_direction = 0
	# If the character is too far from the player (farther than follow_stop_distance). >= because why not.
#	print(relative_x_distance_to_player)
	if abs(relative_x_distance_to_player) >= follow_stop_distance:
		# Transition to WanderState.
		next_state = wander_state
	# If the character is close enough to the player (closer than attack_range).
	# <= because if the player is exactly at attack_range distance units, it should be in range.
	if abs(relative_x_distance_to_player) <= attack_range:
		# Transition to AttackState.
		# I could reset character.velocity.x, but I think it's not that bad if the enemy keeps going after
		# changing state, maybe I could transition back to this state after each attack. To be tested.
		next_state = attack_state
