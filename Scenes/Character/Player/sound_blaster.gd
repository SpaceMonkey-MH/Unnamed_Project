class_name SoundBlasterState
extends WeaponsState

@export var cd_timer: Timer
@export var next_weapon_state: MeleeWeaponState
@export var previous_weapon_state: RailgunState
@export var sound_blaster_area: Area2D
@export var attack_damage: float = 10.0
@export var reload_time: float = 0.2
@export var knockback_force: float = 10.0

# A variable to store whether or not the fire button is pressed. This is used to go around the fact that
# _unhandled_input() doesn't do continuous input (click hold is just a click).
var fire_pressed : bool = false


func _ready() -> void:
	cd_timer.wait_time = reload_time


func state_process(_delta: float) -> void:
	#if Input.is_action_pressed("fire") and can_fire:
		#weapon_fire(character.position, character.get_global_mouse_position(), bullet_2_scene,
			#attack_damage, speed_factor)
		#can_fire = false
		#timer.start()
		#print("mg.gd: ", get_parent().get_parent(), "\n", character)
		#pass
	if fire_pressed and can_fire:
		sound_blaster_area.monitoring = true
		can_fire = false
		cd_timer.start()
		await get_tree().create_timer(0.05).timeout
		sound_blaster_area.monitoring = false
		#print("Fire in sound_blaster.gd.")


func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	# This does not work here, event is only the new ones, not continuous. Trying to go around that.
	# Someone online said I sould add a true argument to is_action_pressed(), but it doesn't work here idk.
	#if event.is_action_pressed("fire") and can_fire:
		#print("Fired in state_input() in weapon2.gd.")
		#weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_2_scene,
			#attack_damage, speed_factor)
		#can_fire = false
		#timer.start()
	# Testing something.
	if event.is_action_pressed("fire"):
		fire_pressed = true
		sound_blaster_area.toggle_visible()
	if event.is_action_released("fire"):
		fire_pressed = false
		sound_blaster_area.toggle_visible()
			


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	cd_timer.paused = false


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	cd_timer.paused = true


func _on_sound_blaster_cool_down_timeout() -> void:
	can_fire = true
#	print("hello2")
