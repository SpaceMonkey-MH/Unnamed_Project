class_name TestShootingEnemy
extends EnemyClass

# Not used currently.
const JUMP_VELOCITY = 0.0
# The speed of the enemy, in pixels/second.
@export var enemy_move_speed = 0.0
# The distance to start following the player. So far it is a 1D follow, so a 1D distance, whatever that means.
@export var follow_distance : float = 0.0
# The distance beyond which the enemy stops following the player, thus transitioning to wander_state.
@export var follow_stop_distance : float = 0.0
# The range of the enemy, meaning the distance below which the enemy starts attacking the player,
# thus transitioning to attack_state.
@export var attack_range : float = 200.0
# The maximum amount of wander_time.
@export var max_wander_time : float = 5.0
# The amount of damage the enemy deals.
@export var damage : float = 25.0
# The time between two attacks, to be assigned to timer.wait_time. To be set in editor.
@export var attack_wait_time : float = 1.0
# The amount of time the sprite will be flashing a color.
@export var flashing_time : float = 0.1
# The color the sprite will be flashing.
@export var flashing_color : Color = Color.RED
# Sprite2D as a variable so it can be modulated (and flipped, I don't know if it's gonna be used).
@export var sprite_2d : Sprite2D
# AnimationTree as a variable, not used for now I think.
@export var animation_tree : AnimationTree
# Half the x size of this enemy plus half the x size of the player plus 5.
# Maybe I need to do this in a cleaner way.
@export var x_size_ep : float = 20 + 20 + 5
# The base damage dealt by this enemy. Should be multiplied by various factors depending on the attack.
@export var attack_damage : float = 10.0
# The AttackHitBox as a variable, so that its radius can be changed.
#@export var attack_hit_box : CollisionShape2D
# Trying to use the notifier in export.
@export var notifier : VisibleOnScreenNotifier2D
# The height of the jump. Added to the character.position.y.
@export var jump_height: float = -500
#var damage_multiplier: float = 1	# Applied to every attack. Or at least the bullet ones.


func _enter_tree() -> void:
	# This is ugly, but I can't find a better way to have the speed exported in this script while making it
	# declared in superclass.
	move_speed = enemy_move_speed


func character_ready() -> void:
#	print("TestMovingEnemy is ready.")
	animation_tree.active = true
	#attack_hit_box.shape.radius = attack_range
	#print("attack_hit_box.shape.radius: ", attack_hit_box.shape.radius)
#	move_speed = SPEED
#	print(move_speed)
	out_of_screen = not notifier.is_on_screen()


# I don't know what I'm doing.
func character_process(_delta) -> void:
	## This should work, but I'd like to try something else.
	#print(notifier.is_on_screen())
	pass


# Replaces the _physics_process() procedure so that the body can be queue freed in the superclass.
func character_physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


# This should not be used anymore, keeping it just in case (and to have the history).
#func _physics_process(delta):
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


func take_damage() -> void:
	sprite_2d.modulate = flashing_color
#	print("hello")
	await get_tree().create_timer(flashing_time).timeout
	sprite_2d.modulate = Color.WHITE


#func death():
#	queue_free()


#func deactivate_node():
#	print("deactivate_node")


# Procedure that is connected to the screen exited signal of the VisibleOnScreenNotifier2D, and that
# calls the procedure that handles what happens when the character is off-screen (queue_free() it if it's dead).
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
#	print("Hello from _on_visible_on_screen_notifier_2d_screen_exited() in attack_dummy.gd (", self, ").")
	#print(self, " is out of screen.")
	out_of_screen = true
	if character_is_dead:
		handle_character_out_of_screen()


func _on_visible_on_screen_notifier_2d_screen_entered():
	out_of_screen = false
