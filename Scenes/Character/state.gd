class_name State

extends Node

signal interrupt_state(new_state : State)

var character : CharacterClass
var playback : AnimationNodeStateMachinePlayback
var next_state : State


func state_process(_delta):
	pass


func state_input(_event : InputEvent):
	pass


func on_enter():
	pass


func on_exit():
	pass
