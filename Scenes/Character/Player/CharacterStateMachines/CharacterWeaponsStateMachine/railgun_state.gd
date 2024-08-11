class_name RailgunState
extends WeaponsState

@export var next_weapon_state: SoundBlasterState
@export var previous_weapon_state: FlameThrowerState
@export var reload_timer: Timer
@export var railgun_projectile_scene: PackedScene
@export var attack_damage: float = 200
# WARNING: this should not be too high, otherwise the projectile doesn't have the time to damage the enemies.
@export var speed_factor: float = 50
@export var reload_time: float = 10
@onready var reload_bar = get_parent().reload_bar


func _ready() -> void:
	reload_timer.wait_time = reload_time


func state_process(delta: float) -> void:
	if not can_fire:
		reload_bar.update_value(-delta * 1000)


func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	if event.is_action_pressed("fire") and can_fire:
		weapon_fire(character.position, character.get_global_mouse_position(), railgun_projectile_scene,
			attack_damage, speed_factor)
		can_fire = false
		reload_timer.start()


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	reload_timer.paused = false
	reload_bar.set_max_value(reload_time * 1000)
	reload_bar.update_value(reload_timer.time_left * 1000)


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	reload_timer.paused = true


func _on_railgun_cool_down_timeout() -> void:
	can_fire = true
	reload_bar.update_value(reload_time * 1000)

