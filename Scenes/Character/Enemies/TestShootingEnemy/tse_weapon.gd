class_name TSEWeapon
extends WeaponsState

# We need a separate script for the shooting part, because we need weapon_fire(), which is in WeaponState class, but we need
# the shooting script to be an AttackState class subclass because reasons. But there are two occurences of the timer part, so
# I withdraw it from here.

#@export var reload_timer: Timer
@export var tse_bullet_scene: PackedScene
# We need a reference to Shoot for the variables.
@export var shoot_state: RangedAttackState
#@export var next_weapon_state: ShotgunState
#@export var previous_weapon_state: MeleeWeaponState
#@export var attack_damage: float = 20
#@export var speed_factor: float = 10
#@export var reload_time: float = 0.8
#@onready var reload_bar = get_parent().reload_bar


#func _ready() -> void:
	#reload_timer.wait_time = reload_time


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
	#if can_fire:
	#print("character in tse_w.gd: ", character)
	#print("Fire in tse_w.gd.")
	weapon_fire(shoot_state.character.global_position, target_pos, tse_bullet_scene, shoot_state.attack_damage,
		shoot_state.speed_factor)
	#weapon_fire(shoot_state.character.position, shoot_state.character.get_global_mouse_position(),
		#tse_bullet_scene, shoot_state.attack_damage, shoot_state.speed_factor)
	#print("shoot_state.character.get_global_mouse_position() in tse_w.gd: ",
		#shoot_state.character.get_global_mouse_position())
		#can_fire = false
		#reload_timer.start()


#func _on_tse_weapon_cool_down_timeout() -> void:
	#can_fire = true
	#reload_bar.update_value(reload_time * 1000)
