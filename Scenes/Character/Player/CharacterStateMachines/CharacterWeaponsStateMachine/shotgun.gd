class_name ShotgunState
extends WeaponsState

@export var timer : Timer
@export var lead_scene : PackedScene
@export var next_weapon_state : RocketLauncherState
@export var previous_weapon_state : DesertEagleState
@export var attack_damage : float = 10
@export var speed_factor : float = 25
@export var reload_time : float = 2
# The spread of the leads, so the total angle of maximum dispersion of the projectiles.
@export var lead_spread : float = PI / 8
# The number of leads (projectiles) fired at each shot.
# If even and not 0, there will be two shots in the middle. If odd, there will be one shot in the middle. 
@export var nb_leads : int = 10


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
		# I feel like it might be easier to refactor the weapon_fire() procedure, Idk.
		# The position of the mouse as a variable, so it is easier to manipulate. It is a vector from the origin
		# to the mouse position.
		var mouse_pos : Vector2 = character.get_global_mouse_position()
		# What we want here, is, for each lead, to call weapon_fire() on a point that depends on the angle
		# computed by: the vector between the character pos and mouse_pos rotated by plus or minus the index of the
		# current lead times the dispersion of the leads divided by the total number of leads. That being said,
		# it is worth noting that when there is an even number of leads, there are two in the "middle", and only
		# one when odd. That means that, when even, we iterate twice, on half the range each time, and when odd we
		# iterate onces on the whole thing.
		# So, we want to take the vector from character to mouse, rotate it, then apply it again to character pos.
		# Computing helper variables for the number of shots.
		# Trying to avoid boilerplate.
		# We don't want to divide by 0, so we exclude this case.
		if nb_leads <= 0:
			return
		# The increment of the angle during the iterations.
		var incr_angle : float = lead_spread / nb_leads
		# The position of the character as a variable so it is easier to manipulate.
		var char_pos : Vector2 = character.position
		# The vector from the character pos to mouse_pos.
		var dir_vector : Vector2 = character.get_global_mouse_position() - char_pos
		# If the number of leads is even (and not 0, 0 has been handled above).
		if nb_leads % 2 == 0:
			# I'm trying to make the two middle projectiles parallel, so I offset the whole thing, or maybe not,
			# I'll see. FF this, too complex to handle for nothing.
			var offset : Vector2 = Vector2(0, 0)
			# We iterate on half that number.
			for shot_angle in range (nb_leads / 2):
				#print("shot_angle: ", shot_angle)
				#print("incr_angle: ", incr_angle)
				# We fire the leads below dir_vector. I'm trying some stuff.
				weapon_fire(char_pos + offset, char_pos + dir_vector.rotated(incr_angle * shot_angle) + offset,
					lead_scene, attack_damage, speed_factor)
				# We fire the leads above dir_vector.
				weapon_fire(char_pos - offset, char_pos + dir_vector.rotated(-incr_angle * shot_angle) - offset,
					lead_scene, attack_damage, speed_factor)
		# If the number of leads is odd.
		else:
			# We fire the middle lead.
			weapon_fire(char_pos, char_pos + dir_vector, lead_scene, attack_damage, speed_factor)
			# We iterate over half the number of leads, starting from 1.
			for shot_angle in range (1, (nb_leads + 1) / 2):
				# We fire above dir_vector.
				weapon_fire(char_pos, char_pos + dir_vector.rotated(incr_angle * (shot_angle)),
					lead_scene, attack_damage, speed_factor)
				# We fire below dir_vector.
				weapon_fire(char_pos, char_pos + dir_vector.rotated(-incr_angle * (shot_angle)),
					lead_scene, attack_damage, speed_factor)
				
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

