class_name TSEWeapon
extends WeaponsState


@export var reload_timer: Timer
@export var tse_bullet_scene: PackedScene
#@export var next_weapon_state: ShotgunState
#@export var previous_weapon_state: MeleeWeaponState
@export var attack_damage: float = 20
@export var speed_factor: float = 10
@export var reload_time: float = 0.8
#@onready var reload_bar = get_parent().reload_bar


func _ready() -> void:
	reload_timer.wait_time = reload_time


#func state_process(delta) -> void:
	## Moved it in state input becasue it is better suited for this purpose.
	##if Input.is_action_just_pressed("fire") and can_fire:
		##weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_1_scene,
		##attack_damage, speed_factor)
		##can_fire = false
		##timer.start()
	#if not can_fire:
		#reload_bar.update_value(-delta * 1000)


func fire(target_pos: Vector2) -> void:
	if can_fire:
		weapon_fire(character.position, target_pos, tse_bullet_scene,
			attack_damage, speed_factor)
		can_fire = false
		reload_timer.start()


func _on_desert_eagle_cool_down_timeout() -> void:
	can_fire = true
	#reload_bar.update_value(reload_time * 1000)
