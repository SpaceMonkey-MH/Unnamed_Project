class_name Napalm
extends Bullet

# How much the projectile penetrates the air (1 - air resistance). The x velocity is multiplied by that factor.
@export var air_penetration_factor : float = 0.99
# Get the gravity from the project settings to be synced with enemy character nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
# 200 is kind of a magic number here, but I don't really know why I need it anyway. It is to balance gravity.
var gravity_divider : float = 200


# Testing how velocity works.
#func _ready() -> void:
	#velocity.x = 100


# Not useful because of superclass.
#func _physics_process(delta) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
		#velocity.x *= air_penetration_factor
	#move_and_slide()


func apply_x_mod(x_velocity : float, delta : float) -> float:
	#print("Hello from apply_x_mod() in napalm.gd. x_velocity: ", x_velocity)
	#print("gravity: ", gravity, "\ndelta: ", delta)
	return x_velocity * air_penetration_factor


func apply_y_mod(y_velocity : float, delta : float) -> float:
	return y_velocity + (gravity / gravity_divider) * delta
