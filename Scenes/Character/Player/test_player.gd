extends CharacterBody2D

#@onready var screen_size = get_viewport_rect().size

const SPEED = 600.0
#const JUMP_VELOCITY = -600.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var gravity = 980


#func _process(delta):
#	print("Test player velocity: ", velocity)



func _physics_process(delta):
#	print(jump_gravity,fall_gravity)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity() * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
#		print("JUMP")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		slow_friction(delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
#	print(direction)
	
	# Screenwrap	
	#position.x = wrapf(position.x, 0, screen_size.x)
	#position.y = wrapf(position.y, 0, screen_size.y)

	move_and_slide()

func slow_friction(d):
	velocity.x -= .02 * d
#	print(velocity)
#	print("SLOW")

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
