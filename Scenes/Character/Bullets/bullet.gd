extends CharacterBody2D

class_name Bullet

var attack_damage : float = 10
var aoe_attack_damage : float = 10
var speed_factor : float = 10
var direction : Vector2 = Vector2.ZERO


func _physics_process(_delta) -> void:
	var collision = move_and_collide(direction.normalized() * speed_factor)
	var attack = Attack.new()
	attack.attack_damage = attack_damage
	if collision != null:
		var collider = collision.get_collider()
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
				area_of_effect()
				# Creates a crash because it hits twice so it can hit something queue_freed.
#				await get_tree().create_timer(0.001).timeout
				queue_free()
		if collider is TileMap:
#			print("hello2")
			explosion_fx()
			area_of_effect()
			queue_free()


func explosion_fx() -> void:
	pass


func area_of_effect():
	pass

#
#func _on_area_entered(area):
#	print(area)
