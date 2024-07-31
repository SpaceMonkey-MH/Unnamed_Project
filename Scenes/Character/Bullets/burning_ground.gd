class_name BurningGround
extends CharacterBody2D

# Get the gravity from the project settings to be synced with enemy character nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
