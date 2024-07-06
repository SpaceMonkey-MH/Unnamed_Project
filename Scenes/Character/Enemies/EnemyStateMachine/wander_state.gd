class_name WanderState
extends EnemyState

# The direction of movement of the character: -1 left, 0 idle, 1 right. To be randomized.
var wander_direction : int = 0
# The maximum amount of wander_time
var max_wander_time : float = 10.0
# Time during which the enemy wanders in that direction. To be randomized.
var wander_time : float = 0.0
# The speed at which the enemy wanders. To be randomized.
var wander_speed : float = 0.0
# Scratch that, this is shit.
## The speed at which the enemy will wander.
#@export var wander_move_speed : float = 50.0


# Called in _physics_process in state machine. 
func state_process(delta):
	character.velocity.x = wander_direction * wander_speed
	wander_time -= delta
	if wander_time <= 0:
		randomize_variables()
#	print(direction, "\n", move_speed, "\n")


func randomize_variables():
	wander_direction = randi_range(-1, 1)
	wander_time = randf_range(0, max_wander_time)
	wander_speed = randf_range(move_speed / 2, move_speed)
#	print(wander_direction, " ", wander_time, " ", wander_speed)


#func wander():
#	# I don't know how to print correctly xd.
#	print(direction, "\n", move_speed, "\n\n")
##	print_rich("Hello from wander() in WanderState.\nDirection: %d.\nMove speed: %f.", direction, move_speed)
#	character.velocity.x = direction * move_speed
##	print("character: ", character)
