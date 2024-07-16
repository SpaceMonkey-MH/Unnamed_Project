extends CharacterBody2D

class_name Bullet

var attack_damage : float = 10.0
var aoe_attack_damage : float = 10.0
var speed_factor : float = 10.0
var direction : Vector2 = Vector2.ZERO
# Putting this here because I don't know where to put it. This is the size of the smallest character in the game,
# used for ray-casting.
var minimum_character_size : float = 40.0
# The size of the AoE/explosion.
var aoe_size : float = 80.0


func _physics_process(_delta) -> void:
	var collision = move_and_collide(direction.normalized() * speed_factor)
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
	#			print("hello")
				explosion_fx()
				area_of_effect(collision.get_position())
				# Creates a crash because it hits twice so it can hit something queue_freed. <-Idk what this means.
#				await get_tree().create_timer(0.001).timeout
				queue_free()
		if collider is TileMap:
#			print("hello2")
			explosion_fx()
			area_of_effect(collision.get_position())
			queue_free()


func explosion_fx() -> void:
	pass


func area_of_effect(_collision_pos):
	pass

#
#func _on_area_entered(area):
#	print(area)
