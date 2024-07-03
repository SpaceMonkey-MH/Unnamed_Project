extends CharacterClass

class_name TestMovingEnemy

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var flashing_time : float = 0.1	# The amount of time the sprite will be flashing a color.
@export var flashing_color : Color = Color.RED	# The color the sprite will be flashing.
# Sprite2D as a variable so it can be modulated (and flipped, I don't know if it's gonna be used).
@export var sprite_2d : Sprite2D

@export var anitmation_tree : AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	anitmation_tree.active = true


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func take_damage():
	sprite_2d.modulate = flashing_color
#	print("hello")
	await get_tree().create_timer(flashing_time).timeout
	sprite_2d.modulate = Color.WHITE

#
#func death():
#	queue_free()
