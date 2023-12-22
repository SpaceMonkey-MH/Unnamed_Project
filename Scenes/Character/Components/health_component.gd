extends Node2D

class_name HealthComponent

signal damaged(node : Node, damage_taken : float)

@export var max_health : float = 100
@export var character : PhysicsBody2D
var health : float :
	get:
		return health
	set(value):
		# Goes (for now) to health_changed_manager.
		SignalBus.emit_signal("health_changed", get_parent(), value - health)
		health = value

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack : Attack):
	health -= attack.attack_damage
	if character.has_method("take_damage"):
		character.take_damage()
#		print(health)
	damaged.emit(get_parent(), attack.attack_damage)	# Goes (for now) to hit_state.
	
#	if health <= 0 and character.has_method("death"):
#		character.death()
