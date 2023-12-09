extends Node2D

class_name HealthComponent

@export var max_health : float = 100
@export var character : PhysicsBody2D
var health : float

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack : Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		character.death()
