class_name MeleeAttackState
extends AttackState


func attack() -> void:
	# Starting the attack cooldown timer.
	timer.start()
	# Setting the Effective attack.
	melee_weapon.monitoring = true
	# Setting the can_attack variable to false so that the enemy can't attack before the end of the timer.
	can_attack = false
	# Waiting a bit for the area monitoring to do its thing.
	await get_tree().create_timer(0.05).timeout
	# Stopping the monitoring thus the attack. Here because otherwise it collides with a new timer, I think.
	melee_weapon.monitoring = false


func jump() -> void:
	character.velocity.y += jump_height
