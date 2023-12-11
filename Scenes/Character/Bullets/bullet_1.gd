extends CharacterBody2D

@export var attack_damage : float = 10
@export var speed_factor : float = 10
var direction : Vector2 = Vector2.ZERO


func _physics_process(delta):
	var collision = move_and_collide(direction.normalized() * speed_factor)
	var attack = Attack.new()
	attack.attack_damage = attack_damage
	if collision != null:
		var collider = collision.get_collider()
		print(collider.has_node("HitBoxComponent"))
		print(collider.get_node("HitBoxComponent"))
#		print(collider)
		if collider.has_node("HitBoxComponent"):
			collider.get_node("HitBoxComponent").damage(attack)
			print("hello")
			queue_free()
			
#
#func _on_area_entered(area):
#	print(area)
