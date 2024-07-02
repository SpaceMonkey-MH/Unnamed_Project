extends CharacterBody2D

class_name Player

# Sources (sjvnnings and kwhitejr): https://gist.github.com/sjvnnings/5f02d2f2fc417f3804e967daa73cccfd

# Defining variables:
@export var move_speed : float = 300.0	# Speed on the movement of the character, in pixels/second.
@export var air_jumps_max : int = 3	# Maximum number of air jumps.
var air_jumps_current : int = air_jumps_max	# Counter of the air jumps done, initialized at air_jumps_max.

# Base variable, not used directly for the jump.
@export var jump_height : float = 120.0	# Height of the jump, in pixels.
@export var jump_time_to_peak : float = 0.5	# Time for the player to reach the peak of the jump, in seconds.
@export var jump_time_to_descent : float = 0.4	# Time to reach the ground during the jump, in seconds.

# Variable directly used for the jump and the falling.
# Velocity applied to the player when jumping.
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
# Gravity applied to the player during the rising part of the jump.
@onready var jump_gravity : float = ((-2.0 * jump_height) /
									(jump_time_to_peak * jump_time_to_peak)) * -1.0
# Gravity applied to the plyaer during the fall.
@onready var fall_gravity : float = ((-2.0 * jump_height) /
									(jump_time_to_descent * jump_time_to_descent)) * -1.0

# CharacterMovementStateMachine as a variable, so that check_if_can_move() can be used.
@onready var movement_state_machine : CharacterMovementStateMachine = $CharacterMovementStateMachine
# BodyAnimationTree as a variable so it can be activated.
@export var body_animation_tree : AnimationTree 
# WeaponsAnimationTree as a variable so it can be activated.
@export var weapons_animation_tree : AnimationTree 
# BodySprite2D as a variable so it can be flipped and modulated.
@export var body_sprite_2d : Sprite2D
# WeaponsSprite2D as a variable so it can be flipped.
@export var weapons_sprite_2d : Sprite2D
# Variable used to smooth the rotation of weapons_sprite_2d in the _process(delta) function.
var smoothed_mouse_pos : Vector2
# Whether or not the player can damage themselves. Used (for now) in the bullet_3 script for the AoE.
@export var self_damage : bool = true	# Should ultimately be likend to options. Might have to move it, Idk.
# Flashing is when the player takes damage.
var flashing_color : Color = Color.CHOCOLATE
var flashing_time : float = 0.1

######################
# Gameplay variables #
######################

var damage_multiplier : float = 1	# Applied to every attack.





# // From template:
#const SPEED = 300.0
##const SPEED = 20
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
#	print(jump_velocity, " ", jump_gravity, " ", fall_gravity)
	body_animation_tree.active = true	# Activating the animation trees so that the animations play.
	weapons_animation_tree.active = true	# Activating the animation trees so that the animations play.
#	rotation_degrees = 180
#	flip_h = true


func _process(_delta):
#	print("Player velocity: ", velocity)
	smoothed_mouse_pos = lerp(smoothed_mouse_pos, get_global_mouse_position(), 0.3)
	weapons_sprite_2d.look_at(smoothed_mouse_pos)


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
	
	# Allows for falling mechanic.
	velocity.y += get_gravity() * delta
	
	# Allows movement of the player. 
	var direction = get_input_direction()	# Get the direction of the input.
	# Apply speed to the player velocity, multiplied by the direction so the player goes the right way,
	# and then by whether the player can move or not.
	velocity.x = direction * move_speed * int(movement_state_machine.check_if_can_move())
	body_sprite_2d.flip_h = direction < 0	# This doesn't do anything yet,
										# because the sprites are symetrical.
										# Maybe this doesn't work at all. It seems to be working.
	weapons_sprite_2d.flip_v = get_local_mouse_position().x < 0	# Flipping the gun so it's not upside down.
#
#	if Input.is_action_just_pressed("jump"):
#		if is_on_floor():
##			jump()
#			pass
##		elif air_jumps_current > 0:
##			pass
##			air_jump()

	move_and_slide()	# Apply the above changes.


# Computes the gravity to use for the player.
func get_gravity():
	# If the player is rising, use the jump_gravity, else use the fall_gravity.
	return jump_gravity if velocity.y < 0.0 else fall_gravity


#
#func jump():
#	air_jumps_current = air_jumps_max
#	velocity.y = jump_velocity

#func air_jump():
#	air_jumps_current -= 1
#	velocity.y = jump_velocity


# Get the direction of the input.
func get_input_direction():
	# If the input is "left", returns -1, if the input is "right", returns 1, if the input is none or both,
	# returns 0.
	return Input.get_axis("left", "right")


# Called by health_component I think.
func take_damage():
#	print(body_sprite_2d)
	body_sprite_2d.modulate = flashing_color
#	print("hello")
	await get_tree().create_timer(flashing_time).timeout
	body_sprite_2d.modulate = Color.WHITE


func death():
	queue_free()
