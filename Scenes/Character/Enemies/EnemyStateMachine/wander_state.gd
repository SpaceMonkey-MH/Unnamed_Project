class_name WanderState
extends EnemyState

# The direction of movement of the character: -1 left, 0 idle, 1 right.
var direction : int = 0


# Called in _physics_process in state machine. 
func state_process(_delta):
	character.velocity.x = direction * move_speed
#	print(direction, "\n", move_speed, "\n")


#func wander():
#	# I don't know how to print correctly xd.
#	print(direction, "\n", move_speed, "\n\n")
##	print_rich("Hello from wander() in WanderState.\nDirection: %d.\nMove speed: %f.", direction, move_speed)
#	character.velocity.x = direction * move_speed
##	print("character: ", character)
