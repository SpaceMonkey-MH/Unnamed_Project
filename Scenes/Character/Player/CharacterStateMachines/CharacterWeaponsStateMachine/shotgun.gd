class_name ShotgunState
extends WeaponsState

@export var timer : Timer
@export var lead_scene : PackedScene
@export var next_weapon_state : RocketLauncherState
@export var previous_weapon_state : DesertEagleState
@export var attack_damage : float = 10
@export var speed_factor : float = 50
@export var reload_time : float = 2
# The spread of the leads, so the total angle of maximum dispersion of the projectiles.
@export var lead_spread : float = PI / 4
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
		# The position of the mouse as a variable, so it is easier to manipulate.
		var mouse_pos : Vector2 = character.get_global_mouse_position()
		# Computing helper variables for the number of shots.
		# Trying to avoid boilerplate.
		# We don't want to divide by 0, so we exclude this case.
		if nb_leads <= 0:
			return
		var incr_angle : float = lead_spread / nb_leads
		if nb_leads % 2 == 0:
			for shot_angle in range (nb_leads / 2):
				print("shot_angle: ", shot_angle)
				print("incr_angle: ", incr_angle)
			
		
		weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), lead_scene,
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

