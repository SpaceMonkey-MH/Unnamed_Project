extends CharacterBody2D

class_name Bullet

# Putting this here because I don't know where to put it. This is the size of the smallest character in the game,
# used for ray-casting.
@export var minimum_character_size : float = 40.0
var attack_damage : float = 10.0
var aoe_attack_damage : float = 10.0
var speed_factor : float = 10.0
var direction : Vector2 = Vector2.ZERO
# The size of the AoE/explosion.
var aoe_size : float = 80.0
var fire_duration : float = 0.0
var fire_damage : float = 0.0
var time_to_effect : float = 0.0
# The movement vector for the bullet.
@onready var mov : Vector2 = direction.normalized() * speed_factor


# This stops rocket.gd from working normally.
#func _ready() -> void:
	#mov = direction.normalized() * speed_factor


func _physics_process(delta) -> void:
	# I'm working on a better way.
	#var collision = move_and_collide(direction.normalized() * speed_factor)
	mov.x = apply_x_mod(mov.x, delta)
	mov.y = apply_y_mod(mov.y, delta)
	var collision = move_and_collide(mov)
	var attack = Attack.new()
	attack.attack_damage = attack_damage
	if collision != null:
		#print("collision.get_position(): ", collision.get_position())
		var collider : Object = collision.get_collider()
#		print(collider.has_node("HitBoxComponent"))
#		print(collider.get_node("HitBoxComponent"))
#		print(collider)
#		if collider.has_node("HitBoxComponent"):
#			collider.get_node("HitBoxComponent").damage(attack)
		for child in collider.get_children():
			if child is HealthComponent:
				child.damage(attack)
				# We check if their is a fire_duration set, which would mean that we want to set on fire.
				if fire_duration != 0.0:
					child.set_on_fire(fire_duration, fire_damage)
	#			print("hello")
				#explosion_fx()
				#area_of_effect()
				# Creates a crash because it hits twice so it can hit something queue_freed. <-Idk what this means.
#				await get_tree().create_timer(0.001).timeout
		explosion_fx()
		area_of_effect()
		queue_free()
		#if collider is TileMap:
##			print("hello2")
			#explosion_fx()
			#area_of_effect()
			#queue_free()


func explosion_fx() -> void:
	pass


func area_of_effect() -> void:
	pass


# This is a placeholder, for air resistance for instance.
func apply_x_mod(x_velocity : float, _delta : float) -> float:
	return x_velocity


# This is a placeholder, for gravity for instance.
func apply_y_mod(y_velocity : float, _delta : float) -> float:
	return y_velocity


#func _on_area_entered(area):
#	print(area)
