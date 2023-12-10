extends Node

class_name CharacterWeaponsStateMachine

@export var current_state : WeaponsState

var states : Array[WeaponsState]

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is WeaponsState:
			states.append(child)	# Maybe this is useless, idk.
			
			# Set the states up with what they need to function
			
		else:
			push_warning("Child " + child.name + "is not a WeaponsState for CharacterWeaponsStateMachine.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(current_state.next_state != null):
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)



func switch_states(new_state : WeaponsState):
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	current_state.on_enter()
#	print("SM: ", current_state)


func _input(event : InputEvent):
	current_state.state_input(event)
