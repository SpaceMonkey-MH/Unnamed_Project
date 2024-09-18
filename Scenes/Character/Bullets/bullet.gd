extends CharacterBody2D

class_name Bullet

# Putting this here because I don't know where to put it. This is the size of the smallest character
# in the game, used for ray-casting.
@export var minimum_character_size: float = 40.0
@export var fuse_timer: Timer
# The area for the damage of the Railgun.
@export var area_2d: Area2D
var attack_damage: float = 10.0
var aoe_attack_damage: float = 10.0
var speed_factor: float = 10.0
# How come this isn't Vector2(0, 0)? Or maybe it is? I don't understand LoL. But ofc, it is set by weapon_fire().
var direction: Vector2 = Vector2.ZERO
#var direction: Vector2 = Vector2(10, 10)
# The size of the AoE/explosion.
var aoe_size: float = 80.0
var fire_duration: float = 0.0
var fire_damage: float = 0.0
# The fuse timer, the time between the launch and the explosion or whatever effect.
var time_to_effect: float = 0.0
# The quantity of fragments emited by the 
var nb_frags: int = 0
# The velocity of the source of the bullet, so the player or an enemy, so the bullet can have its speed affected related to
# that.
var source_velocity: Vector2 = Vector2.ZERO

# This is so that we can do stuff like getting the self_damage value.
#@onready var player : PlayerClass = get_parent().get_parent().get_parent()
# The velocity of the player at the time of the fire.
#@onready var player_velocity : Vector2 = player.velocity
# The movement vector for the bullet. We add the velocity of the player so that the bullet speed depends on
# the speed of the player on fire. Multiply arbitrarily because I can't get delta here.
# WARNING: this creates issues if the speed of the bullet is too low compared to that of the player.
#@onready var mov : Vector2 = direction.normalized() * speed_factor + player_velocity * 0.016
#@onready var mov : Vector2 = (direction.normalized() * speed_factor) + (PlayerVariables.player.velocity /
							#Engine.get_frames_per_second())
# What is direction for here? Apparently something.
#@onready var mov: Vector2 = (direction.normalized() * speed_factor) + (PlayerVariables.player.velocity /
							#Engine.get_frames_per_second())
#@onready var mov: Vector2 = (PlayerVariables.player.velocity / Engine.get_frames_per_second())
@onready var mov: Vector2 = (direction.normalized() * speed_factor) + (source_velocity /
							Engine.get_frames_per_second())


 # This stops rocket.gd from working normally.
#func _ready() -> void:
	#mov = direction.normalized() * speed_factor
	# We add the velocity of the player so that the bullet speed depends on
	# the speed of the player on fire. Divide by the frame rate because I can't get delta here. This means that
	# it will not do well if the frame rate drops.
	# WARNING: this creates issues if the speed of the bullet is too low compared to that of the player.
	#print("mov 1 in bullet.gd: ", mov)
	#mov += player.velocity / Engine.get_frames_per_second()
	#print("mov 2 in bullet.gd: ", mov)


func _physics_process(delta: float) -> void:
	#print("In bullet.gd: ", direction, ", ", direction.normalized(), ", ", direction.normalized() * speed_factor)
	#print("time_to_effect in bullet.gd: ", time_to_effect)
	mov.x = apply_x_mod(mov.x, delta)
	mov.y = apply_y_mod(mov.y, delta)
	#print("mov 1 in bullet.gd: ", mov)
	#mov += player_velocity * delta
	#print("mov 2 in bullet.gd: ", mov)
	# I don't know how to make this simpler.
	if time_to_effect != 0.0:
		velocity = mov * (1 / delta)
		move_and_slide()
	else:
		#print("mov in bullet.gd: ", mov)
		# I'm working on a better way.
		#var collision = move_and_collide(direction.normalized() * speed_factor)
		var collision: KinematicCollision2D = move_and_collide(mov)
		var attack: Attack = Attack.new()
		attack.attack_damage = attack_damage
		if collision != null:
			#print("collision.get_position(): ", collision.get_position())
			var collider: Object = collision.get_collider()
	#		print(collider.has_node("HitBoxComponent"))
	#		print(collider.get_node("HitBoxComponent"))
	#		print(collider)
	#		if collider.has_node("HitBoxComponent"):
	#			collider.get_node("HitBoxComponent").damage(attack)
			for child: Node in collider.get_children():
				#print("child in bullet.gd: ", child)
				if child is HealthComponent:
					child.damage(attack)
					# We check if their is a fire_duration set, which would mean that we want to set on fire.
					if fire_duration != 0.0:
						child.set_on_fire(fire_duration, fire_damage)
		#			print("hello")
					#explosion_fx()
					#area_of_effect()
					# Creates a crash because it hits twice so it can hit something queue_freed.
					# <-Idk what this means.
	#				await get_tree().create_timer(0.001).timeout
			explosion_fx()
			area_of_effect()
			queue_free()
		#if collider is TileMap:
##			print("hello2")
			#explosion_fx()
			#area_of_effect()
			#queue_free()
	#print("Velocity of bullet.gd: ", velocity)
	#print("Player velocity in bullet.gd: ", player_velocity)
	#print("delta in bullet.gd: ", delta)
	#print("Player velocity times delta in bullet.gd: ", player.velocity * delta)
	# Checking whether there is an Area2D set, so that the calls to damage_through() are limited.
	if area_2d:
		damage_through()


func explosion_fx() -> void:
	pass


func area_of_effect() -> void:
	pass


# This is a placeholder, for air resistance for instance.
func apply_x_mod(x_velocity: float, _delta: float) -> float:
	return x_velocity


# This is a placeholder, for gravity for instance.
func apply_y_mod(y_velocity: float, _delta: float) -> float:
	return y_velocity


#func _on_area_entered(area):
	#print(area)


# Placeholder for damaging all along the course of the bullet.
func damage_through() -> void:
	#print("Hello from bullet.gd.")
	pass


func _on_fuse_timer_timeout() -> void:
	explosion_fx()
	area_of_effect()
	queue_free()
