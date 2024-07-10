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
# Debug variable.
var x_velocity = 0
var time


func _ready():
	# Signal damaged from health_component. This can be connected because health_component is an export var.
	health_component.connect("damaged", on_health_component_damaged)


#func _process(_delta):
	#if x_velocity != character.velocity.x:
		#print("character.velocity.x: ", character.velocity.x)
		#x_velocity = character.velocity.x


# Called by StateMachine on transition to self.
func on_enter():
	pass
	#time = Time.get_datetime_dict_from_system()
	#print("%d: HitState entered." % time.second)


# Called by StateMachine on transition from self.
func on_exit():
	pass
	#time = Time.get_datetime_dict_from_system()
	#print("%d: HitState exited." % time.second)


# Connected to damaged signal above.
func on_health_component_damaged(_node : Node, _damage_amount : float):
	# Used to change state when current_state is not self.
	interrupt_state.emit(self)
	# This should stop (stun) the enemy when hit, but it doesn't work consistently.
	# When hit again before the end of the stun, the enemy becomes impervious to stun. Seemingly
	# only when hit during WanderState.
	#print("character.velocity.x = 0 in on_health_component_damaged of HitState.")
	character.velocity.x = 0
	#next_state = # Not needed.
	#print("hello")
	# This is a bit weird, as it is only half of the code for the death (counting DeadState as here).
	if health_component.health > 0:
		#next_state = self	# This does not work, because the next_state is taken only from the current_state.
		# Placeholder for hit animation. That acts as a stun, but maybe it shouldn't stun.
		# Needs fixing anyway (refresh). Should be solved.
		#print("Await in on_health_component_damaged of HitState.")
		await get_tree().create_timer(1.0).timeout
		# Transition to WanderState, because it should cycle back to FollowState or AttackState anyway.
		#next_state = wander_state
		# Same as above. This solved the double stun -> impervious to stun in WanderState (line 182 of Notes.md).
		interrupt_state.emit(wander_state)
		#print("hello2")
	else:
		# Used to change state when self is not the current_state.
		interrupt_state.emit(dead_state)
		# playback.travel(dead_animation_node)	# No animation yet.
