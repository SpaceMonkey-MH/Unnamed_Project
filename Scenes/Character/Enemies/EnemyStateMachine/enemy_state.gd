class_name EnemyState
extends State

# Player as a variable, so that it can be used by the states. To be assigned in the state machine.
var player : CharacterClass
var move_speed : float
# The distance to start following the player. So far it is a 1D follow, so a 1D distance, whatever that means.
var follow_distance : float
# The distance beyond which the enemy stops following the player, thus transitioning to wander_state.
var follow_stop_distance : float
# The range of the enemy, meaning the distance below which the enemy starts attacking the player,
# thus transitioning to attack_state.
var attack_range : float
# The maximum amount of wander_time.
var max_wander_time : float
# The amount of damage the enemy deals.
var damage : float
# The time between two attacks, to be assigned to timer.wait_time. To be set at player.attack_wait_time.
var attack_wait_time : float
