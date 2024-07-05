class_name MovementState
extends State

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


#
#func _ready():
#	print(jump_velocity, " ", jump_gravity, " ", fall_gravity)
