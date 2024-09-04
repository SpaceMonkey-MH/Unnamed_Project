class_name TestShootingEnemy
extends EnemyClass


# Replaces the _physics_process() procedure so that the body can be queue freed in the superclass.
func character_physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
