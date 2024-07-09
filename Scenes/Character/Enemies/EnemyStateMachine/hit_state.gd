class_name HitState
extends EnemyState

# I'm not sure if this should be here, like maybe we don't need a HitState, idk. I think I do.

# Getting the HealthComponent as an export variable so signals can be connected and helth can be gotten. 
@export var health_component : HealthComponent
@export var dead_state : DeadState
# This state as a variable, so it can be transitioned to when hit animation is over.
@export var wander_state : WanderState
# The animation node name, so it can be called. There is no animation yet.
@export var dead_animation_node : String = "dead"


func _ready():
	# Signal damaged from health_component. This can be connected because health_component is an export var.
	health_component.connect("damaged", on_health_component_damaged)


# Connected to signal damaged above.
func on_health_component_damaged(_node : Node, _damage_amount : float):
	character.velocity.x = 0
	#next_state = # Not needed.
	#print("hello")
	if health_component.health > 0:
		# Used to change state when self is not the current_state.
		interrupt_state.emit(self)
		#next_state = self	# This does not work, because the next_state is only from the current_state.
		# Placeholder for hit animation.
		await get_tree().create_timer(1).timeout
		# Transition to WanderState, because it should cycle back to FollowState or AttackState anyway.
		next_state = wander_state
#		print("hello2")
	else:
		# Used to change state when self is not the current_state.
		interrupt_state.emit(dead_state)
		# playback.travel(dead_animation_node)	# No animation yet.
