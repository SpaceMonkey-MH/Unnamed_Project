class_name AttackState
extends EnemyState

# The FollowState as a variable, so it can be transitioned to. To be set in editor.
@export var follow_state: EnemyState
# The cooldwown timer as a variable, so it can be controlled. To be set in editor.
@export var timer: Timer
# MeleeWeapon as a variable, so the monitoring can be toggled. Is this used?
@export var melee_weapon: Area2D
# I wanted to avoid this but(t): whether or not the enemy can attack.
var can_attack: bool = true


# Procedure called on state enter by the StateMachine.
func on_enter() -> void:
	# Setting the attack_wait_time of the cooldown timer to the export variable attack_wait_time set in superclass
	# and StateMachine and main Enemy script.
	timer.wait_time = attack_wait_time
	# If the enemy can attack, and if he is not dead (otherwise, it continues attacking after dying).
	if can_attack and not character.character_is_dead:
		# Calling an attack.
		attack()


# The state version of the _physics_process() procedure, called by the StateMachine.
func state_process(_delta) -> void:
	#print("can_attack for %s in a_s.gd: %s." % [can_attack, self])
	# Using an auxilliary variable to compute the distance to player.
	#var relative_x_distance_to_player = player.position.x - character.position.x
	# This is better (+ same as above).
	var distance_to_player: Vector2 = (player.position - character.position)
	# Jump if the player is higher than this character.
	if -distance_to_player.y > attack_range and character.is_on_floor():
		jump()
	# If the player is too far away.
	if abs(distance_to_player.x) > attack_range:
		# Transition to FollowState.
		next_state = follow_state
	# If the distance between enemy and player is shorter than the sum of half the size of both + 1.
	elif distance_to_player.length() <= x_size_ep:
		# Nullify the x velocity. This is to prevent the enemy from forcing the player into walls and glitching.
		character.velocity.x = 0


# Called by the StateMachine on transition to another state.
func on_exit() -> void:
	pass


# The procedure used to create the attacks. I think I'm gonna overwrite this in a subclass or something.
func attack() -> void:
	pass


func jump() -> void:
	pass


# Connected to the timeout signal of the AttackTimer. Supposed to be the start of a new attack, but there is
# a problem: it attacks continuously, even out of range. 
func _on_attack_timer_timeout() -> void:
	#print("Hello 1.")
	# If the current state is this state. This is to prevent continuous attacks,
	# but not enough to stop the reset of the attack timer on enter.
	if character_movement_state_machine.current_state is AttackState:
		# Call attack() so that it attacks while on range.
		attack()
		#print("Hello 2.")
	# Setting the can_attack variable back to true so that the enemy can attack again.
	can_attack = true
	#melee_weapon.monitoring = false
