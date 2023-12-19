extends WeaponsState

class_name MeleeWeaponState

@export var melee_weapon : Area2D
@export var next_weapon_state : DesertEagle
@export var previous_weapon_state : Weapon8
@export var timer : Timer
@export var attack_damage = 50



var wait_time : float = 0.2


func _ready():
	timer.wait_time = wait_time

#
#func state_process(delta):
#	if Input.is_action_just_pressed("fire"):
#		weapon_fire(get_parent().get_parent().position, player.get_global_mouse_position())	# Warning: not correct!
#		print("fire")	# Will print once per click.
#	if Input.is_action_pressed("fire"):
#		weapon_fire(player.get_global_mouse_position())
#		print("firing")	# Will print continuesly during the hold.
#		print(player.get_global_mouse_position())

func state_input(event : InputEvent):
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	if event.is_action_pressed("fire"):
		melee_weapon.monitoring = true
		timer.start()
		
#	if event.is_action_pressed("fire"):	# Not working as intended, too many or too few "fire".
#		print("fire")

#	print("empty: ", next_state)




func _on_melee_weapon_cool_down_timeout():
	melee_weapon.monitoring = false
