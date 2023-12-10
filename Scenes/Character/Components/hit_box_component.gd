extends Area2D

class_name HitBoxComponent

@export var health_component : HealthComponent
@export var hit_box : CollisionShape2D

func damage(attack : Attack):
	if health_component:
		health_component.damage(attack)
