class_name AttackState
extends EnemyState

# The FollowState as a variable, so it can be transitioned to. To be set in editor.
@export var follow_state : FollowState
# The cooldwown timer as a variable, so it can be controlled. To be set in editor.
@export var timer : Timer
# I wanted to avoid this but(t): whether or not the enemy can attack.
var can_attack : bool = true


# Called at the beginning of the scene.
#func _ready() -> void:
##	print(attack_wait_time)	# Prints 0.
	#pass


# Procedure called on state enter by the StateMachine.
func on_enter() -> void:
	# Setting the attack_wait_time of the cooldown timer to the export variable attack_wait_time set in superclass
	# and StateMachine and main Enemy script.
	timer.wait_time = attack_wait_time
	# If the enemy can attack.
	if can_attack:
		# Calling an attack.
		attack()
	# Starting the attack cooldown timer.
	timer.start()


#func _process(_delta) -> void:
	#print(can_attack)


# The state version of the _physics_process() procedure, called by the StateMachine.
func state_process(_delta) -> void:
	# Using an auxilliary variable to compute the distance to player.
	var relative_x_distance_to_player = player.position.x - character.position.x
	print("relative_x_distance_to_player: ", relative_x_distance_to_player)
	# If the player is too far away.
	if abs(relative_x_distance_to_player) > attack_range:
		# Transition to FollowState.
		next_state = follow_state
	# If the distance between enemy and player is shorter than the sum of half the size of both + 1.
	elif abs(relative_x_distance_to_player) <= x_size_ep:
		# Nullify the x velocity. This is to prevent the enemy from forcing the player into walls and glitching.
		character.velocity.x = 0


# Called by the StateMachine on transition to another state.
func on_exit() ->void:
	print("AttackState exited.")
	# Stop the timer so that it doesn't continuously call attack(). Doesn't work properly, I need to stop
	# the attack() calls from happening while out of range.
#	timer.stop()
	


# The procedure used to create the attacks. I think I'm gonna overwrite this in a subclass or something.
func attack() -> void:
	# Attack placeholder.
	var time = Time.get_datetime_dict_from_system()
	print("%d: Attack!" % [time.second])	# %d" % [10])
	# Setting the can_attack variable to false so that the enemy can't attack before the end of the timer.
	can_attack = false


# Connected to the timeout signal of the AttackTimer. Supposed to be the start of a new attack, but there is
# a problem: it attacks continuously, even out of range. 
func _on_attack_timer_timeout() -> void:
	# If the current state is this state. This is to prevent continuous attacks,
	# but not enough to stop the reset of the attack timer on enter.
	if character_movement_state_machine.current_state is AttackState:
		# Call attack() so that it attacks while on range.
		attack()
	# Setting the can_attack variable back to true so that the enemy can attack again.
	can_attack = true
