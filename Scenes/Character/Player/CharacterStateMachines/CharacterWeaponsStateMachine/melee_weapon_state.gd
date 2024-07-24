extends WeaponsState

class_name MeleeWeaponState

@export var melee_weapon : Area2D
@export var next_weapon_state : DesertEagleState
@export var previous_weapon_state : Weapon8
@export var timer : Timer
@export var attack_damage = 50
@export var reload_time : float = 0.2


func _ready():
	timer.wait_time = reload_time


#func state_process(delta):
	#print("WeaponState melee_weapon.monitoring is ", melee_weapon.monitoring)
	#print("WeaponState can_fire is ", can_fire)
	#print("Time remaining on timer: ", timer.time_left)
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
	# If the player fired, and if it can fire.
	if event.is_action_pressed("fire") and can_fire:
		# Set can_fire to false to prevent from firing again before the end of the cooldown.
		can_fire = false
		# Set the monitoring of the area of melee_weapon to true, so that it detects the overlapping
		# areas (enemies)
		melee_weapon.monitoring = true
		# Start the timer of the cooldown.
		timer.start()
		# Waiting for the monitoring to do its thing. It's not pretty that way, and might lead to issues.
		await get_tree().create_timer(0.05).timeout
		# Stop the monitoring of the area, so that it doesn't damage anymore.
		melee_weapon.monitoring = false
		
#	if event.is_action_pressed("fire"):	# Not working as intended, too many or too few "fire".
#		print("fire")

#	print("empty: ", next_state)



# Called by the timeout of the cooldown timer.
func _on_melee_weapon_cool_down_timeout():
	#print("melee_weapon_cool_down_timeout")
	# Set can_fire back to true so that the player can fire again.
	can_fire = true
	# Stop the monitoring of the area, so that it doesn't damage anymore.
	#melee_weapon.monitoring = false
