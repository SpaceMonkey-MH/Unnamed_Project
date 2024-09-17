class_name RangedAttackState
extends AttackState

@export var tse_weapon: TSEWeapon
@export var speed_factor: float = 5.0
# Reload time in seconds.
#@export var reload_time: float = 2.0


func attack() -> void:
	#print("Attack in r_a_s.gd.")
	tse_weapon.fire(player.global_position)
	# Starting the attack cooldown timer.
	timer.start()
	can_attack = false


# I don't seem to be able to make it work in superclass.
func _on_tse_weapon_cool_down_timeout() -> void:
	#print("Hello 1.")
	#attack()
	# If the current state is this state. This is to prevent continuous attacks,
	# but not enough to stop the reset of the attack timer on enter.
	if character_movement_state_machine.current_state is AttackState:
		# Call attack() so that it attacks while on range.
		attack()
		#print("Hello 2.")
	# Setting the can_attack variable back to true so that the enemy can attack again.
	can_attack = true
