extends Node

class_name State

# Sources (sjvnnings and kwhitejr): https://gist.github.com/sjvnnings/5f02d2f2fc417f3804e967daa73cccfd

# Defining variables:
@export var move_speed = 300.0	# Speed on the movement of the character, in pixels/second.
@export var air_jumps_max : int = 1	# Maximum number of air jumps.
var air_jumps_current : int = air_jumps_max	# Counter of the air jumps done, initialized at air_jumps_max.

# Base variable, not used directly for the jump.
@export var jump_height : float = 100.0	# Height of the jump, in pixels.
@export var jump_time_to_peak : float = 0.5	# Time for the player to reach the peak of the jump, in seconds.
@export var jump_time_to_descent : float = 0.4	# Time to reach the ground during the jump, in seconds.

# Variable directly used for the jump and the falling.
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


@export var can_move : bool = true

var character : CharacterBody2D
var next_state : State



func state_process(delta):
	pass

func state_input(event : InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
