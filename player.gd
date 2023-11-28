extends CharacterBody2D

# Sources (sjvnnings and kwhitejr): https://gist.github.com/sjvnnings/5f02d2f2fc417f3804e967daa73cccfd

@export var move_speed = 300.0
@export var air_jumps_max : int = 1
var air_jumps_current : int = air_jumps_max

@export var jump_height : float = 10000.0
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

# // From template:
#const SPEED = 300.0
##const SPEED = 20
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#func _ready():
#	print(jump_velocity, " ", jump_gravity, " ", fall_gravity)
#
#
#func _process(delta):
#	print("Player velocity: ", velocity)


func _physics_process(delta):
	# // Template from the editor:
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("left", "right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)	# I don't understand what this does. It seems useless.
#	#velocity.x = direction * SPEED	# Not in the template.
#	#print(move_toward(velocity.x, 0, SPEED))	# Not in the template.
	# // End of the template.
	
	
	velocity.y += get_gravity() * delta
	velocity.x = get_input_direction() * move_speed
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif air_jumps_current > 0:
			air_jump()

	move_and_slide()


func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func jump():
	air_jumps_current = air_jumps_max
	velocity.y = jump_velocity

func air_jump():
	air_jumps_current -= 1
	velocity.y = jump_velocity


func get_input_direction():
	return Input.get_axis("left", "right")
