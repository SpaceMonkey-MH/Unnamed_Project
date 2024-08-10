class_name DeadState
extends EnemyState

# I don't really know what to do in this DeadState...


func on_enter():
	#print("DeadState entered.")
	# Just in case, idk.
	# If the enemy is not knocked back.
	if not character.knocked_back:
		character.velocity.x = 0
