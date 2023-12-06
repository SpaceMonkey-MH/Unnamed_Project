extends Node

class_name State


var move_speed : float
var air_jumps_max : int
var air_jumps_current : int

var jump_height : float
var jump_time_to_peak : float
var jump_time_to_descent : float


var jump_velocity : float
var jump_gravity : float
var fall_gravity : float


@export var can_move : bool = true

var player : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var next_state : State



#
#func _ready():
#	print(jump_velocity, " ", jump_gravity, " ", fall_gravity)

func state_process(delta):
	pass

func state_input(event : InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
