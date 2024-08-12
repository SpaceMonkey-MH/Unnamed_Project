class_name FlameThrowerState
extends WeaponsState

@export var reload_timer: Timer
@export var next_weapon_state: RailgunState
@export var previous_weapon_state: GrenadeLauncherState
@export var napalm_scene: PackedScene
@export var attack_damage: float = 10
@export var speed_factor: float = 10
@export var reload_time: float = 0.2
# These are the variables for the burning of the characters.
@export var fire_duration: float = 10.0
@export var fire_damage: float = 10.0

# A variable to store whether or not the fire button is pressed. This is used to go around the fact that
# _unhandled_input() doesn't do continuous input (click hold is just a click).
var fire_pressed: bool = false
@onready var reload_bar = get_parent().reload_bar


func _ready() -> void:
	reload_timer.wait_time = reload_time


func state_process(delta: float) -> void:
	#if Input.is_action_pressed("fire") and can_fire:
		#weapon_fire(character.position, character.get_global_mouse_position(), bullet_2_scene,
			#attack_damage, speed_factor)
		#can_fire = false
		#timer.start()
		#print("mg.gd: ", get_parent().get_parent(), "\n", character)
		#pass
	if fire_pressed and can_fire:
		weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), napalm_scene,
			attack_damage, speed_factor, 0.0, 0.0, fire_duration, fire_damage)
		#print("Hello from state_process() in flame_thrower_state.gd.")
		can_fire = false
		reload_timer.start()
	if not can_fire:
		reload_bar.update_value(-delta * 1000)


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
	if event.is_action_released("fire"):
		fire_pressed = false
			


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	reload_timer.paused = false
	reload_bar.set_max_value(reload_time * 1000)
	if reload_timer.time_left != 0:
		reload_bar.update_value(-reload_time * 1000)
	reload_bar.update_value(reload_timer.time_left * 1000)


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	reload_timer.paused = true


func _on_flame_thrower_cool_down_timeout() -> void:
	can_fire = true
#	print("hello2")
	reload_bar.update_value(reload_time * 1000)


