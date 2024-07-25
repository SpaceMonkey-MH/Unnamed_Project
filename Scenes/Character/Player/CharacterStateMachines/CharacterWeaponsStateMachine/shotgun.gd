class_name ShotgunState
extends WeaponsState

@export var timer : Timer
@export var bullet_1_scene : PackedScene
@export var next_weapon_state : RocketLauncherState
@export var previous_weapon_state : DesertEagleState
@export var attack_damage : float = 20
@export var speed_factor : float = 50
@export var reload_time : float = 2


func _ready() -> void:
	timer.wait_time = reload_time


#func _process(_delta):
	#print("timer.wait_time in shotgun.gd: ", timer.time_left)
	#print("can_fire in shotgun.gd: ", can_fire)


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	if event.is_action_pressed("fire") and can_fire:
		var mouse_pos : Vector2 = character.get_global_mouse_position()
		weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_1_scene,
		attack_damage, speed_factor)
		can_fire = false
		timer.start()


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	timer.paused = false


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	timer.paused = true


func _on_shotgun_cool_down_timeout() -> void:
	can_fire = true

