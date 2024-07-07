class_name AttackDummy
extends EnemyClass


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# The amount of time the sprite will be flashing a color.
@export var flashing_time : float = 0.1
# The color the sprite will be flashing.
@export var flashing_color : Color = Color.RED
# The default color of the dummy. 
@export var base_color : Color = Color.WHITE
# Sprite2D as a variable so it can be modulated (and flipped, I don't know if it's gonna be used).
@export var sprite_2d : Sprite2D
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
## HitBox as a variable, so that it can be disabled.
#@export var hit_box : CollisionShape2D


#func _process(_delta):
#	print("HitBox is disabled: ", hit_box.disabled)


# Replaces the _physics_process() procedure so that the body can be queue freed in the superclass.
func character_physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


# This should not be used anymore, keeping it just in case (and to have the history).
#func _physics_process(delta):
##	print(gravity)
##	print(hit_box)
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
##	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
##		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
##	var direction = Input.get_axis("ui_left", "ui_right")
##	if direction:
##		velocity.x = direction * SPEED
##	else:
##		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()


func take_damage():
	sprite_2d.modulate = flashing_color
#	print("hello")
	await get_tree().create_timer(flashing_time).timeout
	sprite_2d.modulate = base_color


#func death():
#	queue_free()


#func deactivate_node():
#	print("deactivate_node")
#	# What this does is it makes the thing fall. Should not be taking any more damage.
#	hit_box.disabled = true


# Procedure that is connected to the screen exited signal of the VisibleOnScreenNotifier2D, and that
# calls the procedure that handles what happens when the character is off-screen (queue_free() it if it's dead).
func _on_visible_on_screen_notifier_2d_screen_exited():
#	print("Hello from _on_visible_on_screen_notifier_2d_screen_exited() in attack_dummy.gd (", self, ").")
	handle_character_out_of_screen()
