extends EnemyState

class_name HitState

@export var health_component : HealthComponent
@export var dead_state : DeadState
@export var dead_animation_node : String = "dead"

func _ready():
	health_component.connect("damaged", on_health_component_damaged)	# Signal damaged from health_component.

func on_health_component_damaged(node : Node, damage_amount : float):
#	print("hello")
	if health_component.health > 0:
		interrupt_state.emit(self)
#		print("hello2")
	else:
		interrupt_state.emit(dead_state)
		# playback.travel(dead_animation_node)	# No animation yet.
