class_name CharacterClass
extends CharacterBody2D
# Base class for the character, that is to say the player and the enemies.


# HitBox as a variable, so that it can be disabled.
@export var hit_box : CollisionShape2D
# The maximum health of the character.
@export var max_health : float = 100.0
# No magic numbers. This is the time during which the death animation is supposedly plaed (this is just
# a placeholder).
var death_animation_timer : float = 1.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
# Whether or not the character is dead.
var character_is_dead : bool = false
# Timer before queue_free() when the dead characters fall out of the screen.
@export var out_of_screen_death_timer : float = 1.5
## Attempt.
#var character_node
# Move speed of the character, here so it can be added to all the relative states. In pixels/second.
var move_speed : float = 0.0


# Creating a _physics_process() function so that it regroups the test if the body is outside of the screen
# inside the superclass. This is useless for now.
func _physics_process(delta) -> void:
#	print("Move speed of ", self, " from character_class.gd: ", move_speed)
	character_physics_process(delta)
#	print("Hello from _physics_process in character_class.")


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
#	await wait()
#	# Calling the animation anyway.
#	death_animation()
#	# Freeing the queue (== death).
#	queue_free()


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


# Procedure that handles what happens when a character is out of screen; called by the procedure connected
# to the VisibleOnScreenNotifier2D of the character.
func handle_character_out_of_screen() -> void:
	if character_is_dead:
		await get_tree().create_timer(out_of_screen_death_timer).timeout
		queue_free()
		#print("queue_free() of ", self)
