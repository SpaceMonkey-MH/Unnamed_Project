class_name BurningGround
extends CharacterBody2D

@export var burning_ground_area : BurningGroundArea
# Get the gravity from the project settings to be synced with enemy character nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
# Variables here so that they can be set by the instantiator and can then set the $BurningGroundArea variables.
var burn_time : float = 5.0
var burn_damage : float = 10.0


func _ready():
	burning_ground_area.burn_time = burn_time
	burning_ground_area.burn_damage = burn_damage


func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()


func _on_time_burning_ground_timer_timeout():
	queue_free()
