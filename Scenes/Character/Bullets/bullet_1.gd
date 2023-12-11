extends CharacterBody2D

@export var attack_damage : float = 10
var direction : Vector2 = Vector2.ZERO


func _physics_process(delta):
	move_and_collide(direction.normalized())

func _on_area_entered(area):
	print(area)
