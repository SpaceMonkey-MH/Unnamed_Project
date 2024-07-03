class_name CharacterClass
extends CharacterBody2D
# Base class for the character, that is to say the player and the enemies.


# No magic numbers.
var death_animation_timer = 1.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
## This is a bad idea...
#@export var hit_box : CollisionShape2D


# Base function used for the death of the character, to be overwritten but useful if I forget to do so
# (or if I'm lazy). Or if it just works better that way, kind of like how the bullet
# _physics_process() function works.
func death():
	print("hello")
	# We need to deactivate the character node without freeing it, so that it doesn't interact too much anymore,
	# but it's still there for the damage label.
	deactivate_node()
	# This is temporary, it is used to simulate the animation.
	# Also, should allow the damage label to exist on death.
	# Actually, I have a better idea, let's put it in another function.
	await wait()
	# Calling the animation anyway.
	death_animation()
	# Freeing the queue (== death).
	queue_free()


func deactivate_node():
	pass


# This is used to wait before the node is queue-freed.
# This is a separate function so that it can be overwritten in extending classes.
# This doesn't work, and I don't know why...
func wait():
	print("Hello from wait() in character_class, before the await call.")
	await get_tree().create_timer(death_animation_timer).timeout
	print("Hello from wait() in character_class, after the await call.")


# This is meant to be overwritten.
func death_animation():
	pass
