extends EnemyState


class_name HitState


# Getting the HealthComponent as an export variable so signals can be connected and helth can be gotten. 
@export var health_component : HealthComponent
@export var dead_state : DeadState
@export var dead_animation_node : String = "dead"


func _ready():
	# Signal damaged from health_component. This can be connected because health_component is an export var.
	health_component.connect("damaged", on_health_component_damaged)


func on_health_component_damaged(_node : Node, _damage_amount : float):
#	print("hello")
	if health_component.health > 0:
		interrupt_state.emit(self)
#		print("hello2")
	else:
		interrupt_state.emit(dead_state)
		# playback.travel(dead_animation_node)	# No animation yet.
