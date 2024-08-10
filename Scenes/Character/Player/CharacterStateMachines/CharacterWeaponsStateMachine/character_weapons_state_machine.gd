extends Node

class_name CharacterWeaponsStateMachine

@export var character : CharacterBody2D
@export var current_state : WeaponsState
# The different weapons as variables so they can be transitioned to.
@export var weapon_0_state: MeleeWeaponState
@export var weapon_1_state: DesertEagleState
@export var weapon_2_state: ShotgunState
@export var weapon_3_state: RocketLauncherState
@export var weapon_4_state: FireSpitterState
@export var weapon_5_state: MachineGunState
@export var weapon_6_state: GrenadeLauncherState
@export var weapon_7_state: FlameThrowerState
@export var weapon_8_state: RailgunState
@export var weapon_9_state: SoundBlasterState

var states : Array[WeaponsState]

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is WeaponsState:
			states.append(child)	# Maybe this is useless, idk.
			
			# Set the states up with what they need to function
			child.character = character
			
		else:
			push_warning("Child " + child.name + " is not a WeaponsState for CharacterWeaponsStateMachine.")

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


func _unhandled_input(event : InputEvent):
	#if Input.is_action_pressed("fire"):
		#print("event of _input() in CWSM: ", event)
	current_state.state_input(event)
	if event.is_action_pressed("weapon_0"):
		switch_states(weapon_0_state)
	if event.is_action_pressed("weapon_1"):
		switch_states(weapon_1_state)
	if event.is_action_pressed("weapon_2"):
		switch_states(weapon_2_state)
	if event.is_action_pressed("weapon_3"):
		switch_states(weapon_3_state)
	if event.is_action_pressed("weapon_4"):
		switch_states(weapon_4_state)
	if event.is_action_pressed("weapon_5"):
		switch_states(weapon_5_state)
	if event.is_action_pressed("weapon_6"):
		switch_states(weapon_6_state)
	if event.is_action_pressed("weapon_7"):
		switch_states(weapon_7_state)
	if event.is_action_pressed("weapon_8"):
		switch_states(weapon_8_state)
	if event.is_action_pressed("weapon_9"):
		switch_states(weapon_9_state)
