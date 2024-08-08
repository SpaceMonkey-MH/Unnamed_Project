extends WeaponsState

class_name MeleeWeaponState

@export var melee_weapon_area: Area2D
@export var melee_weapon_char: CharacterBody2D
@export var next_weapon_state: DesertEagleState
@export var previous_weapon_state: RailgunState
@export var reload_timer: Timer
# The timer that controls the duration of the flight of the thrown weapon (only the outward part).
@export var throw_duration_timer: Timer
@export var attack_damage: float = 50.0
@export var reload_time: float = 0.2
# The time for which the thrown weapon is going to fly outwards.
@export var throw_duration: float = 3.0
# Speed of the flying weapon. Idk the unit.
@export var flying_speed: float = 300
# 1 if the weapon is flying outwards, -1 if it is flying inwards, 0 otherwise.
var flying_away: int = 0
@onready var hit_box: Node = get_node("../../MeleeWeaponChar/MeleeWeaponHitBox")


func _ready() -> void:
	reload_timer.wait_time = reload_time
	throw_duration_timer.wait_time = throw_duration
	#print('get_node("../MeleeWeaponChar/MeleeWeaponHitBox"): ', get_node(
		#"../../MeleeWeaponChar/MeleeWeaponHitBox"))
	# Can't seem to get the hit box from melee_weapon_char.
	hit_box.disabled = true


func state_process(_delta: float) -> void:
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
	if flying_away == 1:
		#var fly_angle: float = Vector2(1, 0).angle_to_point(character.get_local_mouse_position())
		#print("angle in m_w_s.gd: ", fly_angle)
		#melee_weapon_char.velocity = Vector2(100, 0).rotated(fly_angle)
		#melee_weapon_char.velocity = melee_weapon_char.get_local_mouse_position().normalized() * flying_speed
		var mouse_pos: Vector2 = melee_weapon_char.get_local_mouse_position()
		# This is to avoid weird twitching when the cursor in near the pos.
		if mouse_pos.length() < 5:
			mouse_pos = Vector2.ZERO
		#print("mouse_pos in m_w_s.gd: ", mouse_pos)
		melee_weapon_char.velocity = lerp(melee_weapon_char.velocity,
			mouse_pos.normalized() * flying_speed, 0.3)
		#if melee_weapon_char.velocity.length() >= 10:
		melee_weapon_char.move_and_slide()
		

func state_input(event : InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	# If the player fired, and if it can fire.
	if event.is_action_pressed("fire") and can_fire:
		# Set can_fire to false to prevent from firing again before the end of the cooldown.
		can_fire = false
		# Set the monitoring of the area of melee_weapon_area to true, so that it detects the overlapping
		# areas (enemies)
		melee_weapon_area.monitoring = true
		# Start the timer of the cooldown.
		reload_timer.start()
		# The angle of progression of the rotation of the sprite. Two times PI divided by the base fps.
		# This makes a rotation in one second, but it needs to be shorter. Idk how to make that relative to
		# the "reload" time. Found it kinda, now taking the min between 1 and reload_time, so that the animation
		# doesn't last longer than a second nor than the reload time. Breaks if the reload time is set too low
		# (0.1 at least is fine).
		var prog_angle: float = (2 * PI) / (60 * min(1, reload_time))
		for i in range((2 * PI) / prog_angle):
			melee_weapon_char.rotate(prog_angle)
			# Divide by 60 for a 1 second or less animation.
			await get_tree().create_timer(1 / 60).timeout
		# Waiting for the monitoring to do its thing. It's not pretty that way, and might lead to issues.
		await get_tree().create_timer(0.05).timeout
		# Stop the monitoring of the area, so that it doesn't damage anymore.
		melee_weapon_area.monitoring = false
	if event.is_action_pressed("secondary_fire") and can_fire:
		throw_weapon(character.get_global_mouse_position())
		#print("mouse_pos in melee_w_s.gd", character.get_global_mouse_position())
		
#	if event.is_action_pressed("fire"):	# Not working as intended, too many or too few "fire".
#		print("fire")

#	print("empty: ", next_state)


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	reload_timer.paused = false
	melee_weapon_char.visible = true


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	reload_timer.paused = true
	melee_weapon_char.visible = false


func throw_weapon(mouse_pos: Vector2) -> void:
	can_fire = false
	throw_duration_timer.start()
	#melee_weapon.visible = false
	flying_away = 1
	#while flying_away:
		#melee_weapon_char.velocity = Vector2(10, 0)
		#melee_weapon_char.move_and_slide()
		#print("Hello from thrown_weapon() in melee_weapon_state.gd")
	melee_weapon_area.monitoring = true
	hit_box.disabled = false
	


# Called by the timeout of the cooldown timer.
func _on_melee_weapon_cool_down_timeout() -> void:
	#print("melee_weapon_cool_down_timeout")
	# Set can_fire back to true so that the player can fire again.
	can_fire = true
	# Stop the monitoring of the area, so that it doesn't damage anymore.
	#melee_weapon.monitoring = false


func _on_melee_weapon_throw_duration_timeout() -> void:
	reload_timer.start()
	melee_weapon_char.visible = true
	flying_away = -1
	melee_weapon_area.monitoring = false
	hit_box.disabled = true
