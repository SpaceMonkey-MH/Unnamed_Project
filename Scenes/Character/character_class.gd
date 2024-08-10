class_name CharacterClass
extends CharacterBody2D

# Base class for the characters, that is to say the player and the enemies.

# HitBox as a variable, so that it can be disabled.
@export var hit_box: HitBoxClass
# I'm trying stuff with the visible on screen notifier, in oreder to properly queue free the characters when dead.
#@export var notifier = VisibleOnScreenNotifier2D
# The maximum health of the character.
@export var max_health: float = 100.0
# Timer before queue_free() when the dead characters fall out of the screen.
@export var out_of_screen_death_timer: float = 1.5
# Whether or not the character is out of screen. Used to queue free it when dead. Initialized here for placeholder
# but really set in _ready() in subclasses.
@export var out_of_screen: bool = false
# The amount of air penetration (1 - air resistance). Will be multiplied by the velocity of the character.
# Maybe this should be in level script, to be seen.
@export var air_penetration: float = 0.99
# No magic numbers. This is the time during which the death animation is supposedly played (this is just
# a placeholder).
var death_animation_timer: float = 1.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
# Whether or not the character is dead. I think this is useless? Maybe not.
var character_is_dead: bool = false
# Move speed of the character, here so it can be added to all the relative states. In pixels/second.
var move_speed: float = 0.0
# Whether or not the player can move, use for knockback.
var knocked_back: bool = false


func _ready():
	character_ready()


# Creating a _process() procedure so that there can be code inside it and inside the functions in subclasses.
# This is useless for now.
func _process(delta) -> void:
#	print("Move speed of ", self, " from character_class.gd: ", move_speed)
	character_process(delta)
#	print("Hello from _physics_process in character_class.")
	# Doesn't seem to work. I Apparently cannot do this in superclass, idk.
	#print(notifier.is_on_screen())


# Creating a _physics_process() procedure so that it regroups the test if the body is outside of the screen
# inside the superclass. This is useless for now.
func _physics_process(delta) -> void:
#	print("Move speed of ", self, " from character_class.gd: ", move_speed)
	character_physics_process(delta)
	# Simulate air resistance.
	velocity *= air_penetration
#	print("Hello from _physics_process in character_class.")


# Just a placeholder.
func character_ready():
	pass


# Just a placeholder.
func character_process(_delta) -> void:
	pass


# Just a placeholder.
func character_physics_process(_delta) -> void:
	pass


# Base function used for the death of the character, to be overwritten but useful if I forget to do so
# (or if I'm lazy). Or if it just works better that way, kind of like how the bullet
# _physics_process() function works.
func death() -> void:
#	print("Death of the character: ", self)
	# We need to deactivate the character node without freeing it, so that it doesn't interact too much anymore,
	# but it's still there for the damage label.
	deactivate_node()
	#print("deactivate_node() of ", self)
	character_is_dead = true
#	# This is temporary, it is used to simulate the animation.
#	# Also, should allow the damage label to exist on death.
#	# Actually, I have a better idea, let's put it in another function, and withdraw it when needed.
	# Actu-actually, it is useless now (see below), keeping just in case.
#	await wait()
#	# Calling the animation anyway.
#	death_animation()
#	# Freeing the queue (== death). It is better if it is after the character has exited the screen.
#	queue_free()
	# Changing the Z-index so that the character is visible when falling through the ground.
	z_index += 2
	## Trying to queue free when out of screen.
	#while not out_of_screen:
		## Passing the time to allow the character to fall out of the screen.
		#await get_tree().create_timer(0.1)
	#await get_tree().create_timer(out_of_screen_death_timer).timeout
	#queue_free()
	#print("queue_free() of ", self)
	if out_of_screen:
		handle_character_out_of_screen()
	


func deactivate_node() -> void:
	# Idk why, but it showed errors when killing that way, so I deferred it instead. Actually,
	# it doesn't work with deferred. IDK. Maybe I was using it wrong.
	hit_box.disabled = true


# This is used to wait before the node is queue-freed.
# This is a separate function so that it can be overwritten in extending classes.
# This doesn't work, and I don't know why...
# Ok now I know why, I had to await the call to wait() in death().
func wait() -> void:
#	print("Hello from wait() in character_class, before the await call.")
	await get_tree().create_timer(death_animation_timer).timeout
#	print("Hello from wait() in character_class, after the await call.")


# This is meant to be overwritten.
func death_animation() -> void:
	pass


# I think this is useless now, Idk.
# Procedure that handles what happens when a character is out of screen; called by the procedure connected
# to the VisibleOnScreenNotifier2D of the character.
func handle_character_out_of_screen() -> void:
	#if character_is_dead:
	await get_tree().create_timer(out_of_screen_death_timer).timeout
	queue_free()
	#print("queue_free() of ", self)


func knockback(source_pos: Vector2, mouse_pos: Vector2, knockback_force: float) -> void:
	knocked_back = true
	#print("character_class.gd: source_pos: %s, global_position: %s" % [source_pos, global_position])
	velocity += (mouse_pos - source_pos).normalized() * knockback_force
	print("character_class.gd: velocity: ", velocity)
	move_and_slide()


func stop_knockback() -> void:
	knocked_back = false
