extends WeaponsState

class_name Weapon3

@export var reload_timer : Timer
@export var next_weapon_state : Weapon4
@export var previous_weapon_state : Weapon2
@export var bullet_3_scene : PackedScene
@export var attack_damage : float = 0
@export var aoe_attack_damage : float = 50
@export var speed_factor : float = 5

var wait_time : float = 1.5


func _ready():
	reload_timer.wait_time = wait_time
#	print(timer.wait_time)

func state_process(_delta):
#	print(can_fire)
	if Input.is_action_just_pressed("fire") && can_fire:
		weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_3_scene,
		attack_damage, speed_factor, aoe_attack_damage)
		can_fire = false
		reload_timer.start()

func state_input(event : InputEvent):
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state


func _on_weapon_3_cool_down_timeout():
	can_fire = true
#	print("hello")
