class_name Weapon2
extends WeaponsState

@export var timer : Timer
@export var next_weapon_state : Weapon3
@export var previous_weapon_state : DesertEagleState
@export var bullet_2_scene : PackedScene
@export var attack_damage : float = 10
@export var speed_factor : float = 12
@export var reload_time : float = 0.2


func _ready() -> void:
	timer.wait_time = reload_time


func state_process(_delta) -> void:
	if Input.is_action_pressed("fire") and can_fire:
		weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_2_scene,
		attack_damage, speed_factor)
		can_fire = false
		timer.start()
		#pass


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	# This does not work here, event is only the new ones, not continuous.
	#if Input.is_action_pressed("fire") and can_fire:
		#print("Fired in state_input() in weapon2.gd.")
		#weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_2_scene,
		#attack_damage, speed_factor)
		#can_fire = false
		#timer.start()


func _on_weapon_2_cool_down_timeout() -> void:
	can_fire = true
#	print("hello2")

