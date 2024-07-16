class_name Weapon3
extends WeaponsState

@export var reload_timer : Timer
@export var next_weapon_state : Weapon4
@export var previous_weapon_state : Weapon2
@export var bullet_3_scene : PackedScene
@export var attack_damage : float = 0
@export var aoe_attack_damage : float = 40
# The size of the explosion, used for ray-casting.
@export var aoe_size : float = 80.0
@export var speed_factor : float = 5

var wait_time : float = 1.5


func _ready() -> void:
	reload_timer.wait_time = wait_time
#	print(timer.wait_time)


func state_process(_delta) -> void:
#	print(can_fire)
	if Input.is_action_just_pressed("fire") and can_fire:
		weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_3_scene,
		attack_damage, speed_factor, aoe_attack_damage, aoe_size)
		can_fire = false
		reload_timer.start()


func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state


func _on_weapon_3_cool_down_timeout() -> void:
	can_fire = true
#	print("hello")

