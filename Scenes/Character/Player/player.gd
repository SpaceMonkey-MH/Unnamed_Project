class_name PlayerClass
extends CharacterClass


### Sources (sjvnnings and kwhitejr): https://gist.github.com/sjvnnings/5f02d2f2fc417f3804e967daa73cccfd

## Defining variables:
# Speed on the movement of the player, in pixels/second.
@export var player_move_speed : float = 300.0
# Maximum number of air jumps.
@export var air_jumps_max : int = 3
# Counter of the air jumps done, initialized at air_jumps_max.
var air_jumps_current : int = air_jumps_max

## Base variables, not used directly for the jump.
# Height of the jump, in pixels.
@export var jump_height : float = 120.0
# Time for the player to reach the peak of the jump, in seconds.
@export var jump_time_to_peak : float = 0.5
# Time to reach the ground during the jump, in seconds.
@export var jump_time_to_descent : float = 0.4

## Variables directly used for the jump and the falling:
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
# WeaponsSprite2D as a variable so it can be flipped and rotated.
@export var weapons_sprite_2d : Sprite2D
# FireSpitterWeapon as a variable so it can be rotated.
@export var fire_spitter_area_2D : Area2D
# FireSpitter sprite (for now, a color rect) as a variable so it can be flipped.
@export var fire_spitter_sprite_2d : Sprite2D
# Whether or not the player can damage themselves. Used (for now) in the bullet_3 script for the AoE.
@export var self_damage : bool = true	# Should ultimately be likend to options. Might have to move it, Idk.
# Flashing is when the player takes damage.
@export var flashing_color : Color = Color.CHOCOLATE
@export var flashing_time : float = 0.1
# Variable used to smooth the rotation of weapons_sprite_2d in the _process(delta) function.
var smoothed_mouse_pos : Vector2
## Just testing smth.
#var angle = 0

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


# Executed at the beginning of runtime.
func _enter_tree():
	# This is ugly, but I can't find a better way to have the speed exported in this script while making it
	# declared in superclass.
	move_speed = player_move_speed
	assert(move_speed == 300, "move_speed is not equal to 300.")
#	assert(move_speed != 300, "move_speed is equal to 300.")
#	assert(move_speed == 0)


# Executed at the beginning of runtime, after _enter_tree().
func _ready():
	#print(85 * 191)
#	print("Player is ready.")
#	# This is ugly, but I can't find a better way to have the speed exported in this script while making it
#	# declared in superclass.
#	move_speed = player_move_speed
#	print("player: ", move_speed)
#	print(jump_velocity, " ", jump_gravity, " ", fall_gravity)
	body_animation_tree.active = true	# Activating the animation trees so that the animations play.
	weapons_animation_tree.active = true	# Activating the animation trees so that the animations play.
#	rotation_degrees = 180
#	flip_h = true


func _process(_delta):
#	print("Player velocity: ", velocity)
	smoothed_mouse_pos = lerp(smoothed_mouse_pos, get_global_mouse_position(), 0.3)
	weapons_sprite_2d.look_at(smoothed_mouse_pos)
	fire_spitter_area_2D.look_at(smoothed_mouse_pos)
	# Flipping the sprite so it looks the right direction.
	body_sprite_2d.flip_h = get_local_mouse_position().x < 0
	# Flipping the gun so it's not upside down.
	weapons_sprite_2d.flip_v = get_local_mouse_position().x < 0
	# I don't think I need to flip the fire spitter, as it is symetrical, but it might change.
	# This doesn't work.
	#fire_spitter_area_2D.flip_v = get_local_mouse_position().x < 0
	# This does work. And I think I need to flip it, otherwise the flames will be upside down.
	fire_spitter_sprite_2d.flip_v = get_local_mouse_position().x < 0
	## Testings.
	#angle += 0.05
	#rotate(angle)
#	print("player: ", move_speed)


# Replaces the _physics_process() procedure so that the body can be queue freed in the superclass.
func character_physics_process(delta):
#	print("Player velocity: ", velocity)
	# Allows for falling mechanic.
	velocity.y += get_gravity() * delta
	# Allows movement of the player. 
	var direction = get_input_direction()	# Get the direction of the input.
	# Apply speed to the player velocity, multiplied by the direction so the player goes the right way,
	# and then by whether the player can move or not.
	velocity.x = direction * move_speed * int(movement_state_machine.check_if_can_move())
	# Apply the above changes.
	move_and_slide()



# This should not be used anymore, keeping it just in case (and to have the history).
#func _physics_process(delta):
#	# // Template from the editor:
##	# Add the gravity.
##	if not is_on_floor():
##		velocity.y += gravity * delta
##
##	# Handle Jump.
##	if Input.is_action_just_pressed("jump") and is_on_floor():
##		velocity.y = JUMP_VELOCITY
##
##	# Get the input direction and handle the movement/deceleration.
##	# As good practice, you should replace UI actions with custom gameplay actions.
##	var direction = Input.get_axis("left", "right")
##	if direction:
##		velocity.x = direction * SPEED
##	else:
##		velocity.x = move_toward(velocity.x, 0, SPEED)	# I don't understand what this does. It seems useless.
##	#velocity.x = direction * SPEED	# Not in the template.
##	#print(move_toward(velocity.x, 0, SPEED))	# Not in the template.
#	# // End of the template.
#
#	# Allows for falling mechanic.
#	velocity.y += get_gravity() * delta
#
#	# Allows movement of the player. 
#	var direction = get_input_direction()	# Get the direction of the input.
#	# Apply speed to the player velocity, multiplied by the direction so the player goes the right way,
#	# and then by whether the player can move or not.
#	velocity.x = direction * move_speed * int(movement_state_machine.check_if_can_move())
#	# This doesn't do anything yet, because the sprites are symetrical.
#	# Maybe this doesn't work at all. It seems to be working.
#	# I think it can be done better, like the body sprite should flip with the mouse cursor I think,
#	# this would solve the idle issue (when not moving, the sprite always looks to the right).
##	body_sprite_2d.flip_h = direction < 0
#	# Flipping the spite so it looks the right direction.
#	body_sprite_2d.flip_h = get_local_mouse_position().x < 0
#	# Flipping the gun so it's not upside down.
#	weapons_sprite_2d.flip_v = get_local_mouse_position().x < 0
##
##	if Input.is_action_just_pressed("jump"):
##		if is_on_floor():
###			jump()
##			pass
###		elif air_jumps_current > 0:
###			pass
###			air_jump()
#
#	move_and_slide()	# Apply the above changes.


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


#func death():
#	queue_free()


#func deactivate_node():
#	print("deactivate_node")


# Don't know if it is a good idea to queue_free() the player, idk how it's gonna go with the respawn and all.
## Procedure that is connected to the screen exited signal of the VisibleOnScreenNotifier2D, and that
## calls the procedure that handles what happens when the character is off-screen (queue_free() it if it's dead).
#func _on_visible_on_screen_notifier_2d_screen_exited():
##	print("Hello from _on_visible_on_screen_notifier_2d_screen_exited() in attack_dummy.gd (", self, ").")
#	handle_character_out_of_screen()
