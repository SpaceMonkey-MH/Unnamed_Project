class_name State
extends Node

signal interrupt_state(new_state : State)

# The state machine as an export variable, so that it can be referenced to in subclasses.
@export var character_movement_state_machine : CharacterMovementStateMachine
var character : CharacterClass
var playback : AnimationNodeStateMachinePlayback
var next_state : State


func state_process(_delta) -> void:
	pass


func state_input(_event : InputEvent) -> void:
	pass


func on_enter() -> void:
	pass


func on_exit() -> void:
	pass
