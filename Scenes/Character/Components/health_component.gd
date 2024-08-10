extends Node2D
class_name HealthComponent
# Component for the health of the characters, used to store health and take damage,
# that is to say reduce health, as well as death. Ultimately, should incorporate various other features,
# such as healing (kinda here, like negative damage, or maybe positive ? Idk).


signal damaged(node : Node, damage_taken : float)

## I'm gonna need to find a solution to the issue of the max health (cf Notes.md).
# Trying to have this in the character code.
## The maximum amount of health the character can have.
#@export var max_health : float = 100
# The character as a variable, so that it can be damaged.
@export var character : CharacterClass
# The timer storing the time of "on fire" left as a variable so it can be started.
@export var on_fire_timer : Timer
# The sound "allumer le feu" from the song, as a variable so it can be played. For now it is not the correct
# but it will change soon. Be careful of copyrights.
@export var allumer_le_feu_sound : AudioStreamPlayer
# Whether or not the above sound should be played when something is set on fire.
#var allumer_le_feu_plays : bool = false
## The wait time of that timer.
#@export var on_fire_wait_time : float = 5.0
# Debug variable, used to execute code every second.
var t : float = 0.0
# Whether or not the character is on fire.
var on_fire : bool = false
# The value of the fire damage, which will be applied to health.
var fire_damage : float = 10.0
# Whether or not the above sound should be played when something is set on fire.
@onready var allumer_le_feu_plays: bool = PlayerVariables.player.special_sounds
# The health of the character, initialized to the max health, with a setter and a getter.
@onready var health : float = character.max_health :
	get:
		return health
	set(value):
		# Goes (for now) to health_changed_manager.
		if value > character.max_health:
			#SignalBus.emit_signal("health_changed", get_parent(),
				#min(value - health, character.max_health - health))
			health = character.max_health
		else:
			SignalBus.emit_signal("health_changed", get_parent(), value - health)
			#print("Hello from health setter in health_component.")
			health = value
#		print("Set health in HealthComponent in ", get_parent(), " to: ", health)


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#print("Hello from health_component.gd with parent: ", get_parent())
	#print("Health Component Timer: ", on_fire_timer)
	# Just here to simulate a call.
	#set_on_fire(2.0, 10.0)
	#on_fire_timer.wait_time = on_fire_wait_time
	# Get the special sound value from the player global variable.
	#allumer_le_feu_plays = PlayerVariables.player.special_sounds
	#print("Allumer le feu: ", allumer_le_feu_sound)
	#allumer_le_feu_sound.play()
	#print("allumer_le_feu_plays: ", allumer_le_feu_plays)


func _process(delta) -> void:
	if get_parent().character_is_dead:
		return
	t += delta
	if t >= 1:
		#var time = Time.get_datetime_dict_from_system()
		#print(time.second, " ", get_parent(), ": ", on_fire)
		# I don't know how this doesn't overlap or whatever, but I'll take it.
		if on_fire:
			# Creating an attack.
			var attack : Attack = Attack.new()
			attack.attack_damage = fire_damage
			damage(attack)
		health += 10
		t = 0.0


# Should be a function that handles the setting target on fire part, taking a duration and a damage for the burn.
# I don't know how this doesn't overlap or whatever, but I'll take it.
func set_on_fire(fire_duration : float = 5.0, f_damage : float = 10.0) -> void:
	if fire_duration != 0.0:
		on_fire_timer.wait_time = fire_duration
		#if on_fire_timer.time_left == 0.0:
			#on_fire_timer.start()
		#else:
			#print("Timer stopped and re-started in set_on_fire() in health_component.gd.")
			#on_fire_timer.stop()
			#on_fire_timer.start()
		on_fire_timer.stop()
		on_fire_timer.start()
		fire_damage = f_damage
		on_fire = true
		#print("PlayerVariables.player.special_sounds in h_c.gd: ", PlayerVariables.player.special_sounds)
		if allumer_le_feu_plays:
			allumer_le_feu_sound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack : Attack = Attack.new()) -> void:
	health -= attack.attack_damage
	if character.has_method("take_damage"):
		character.take_damage()
#		print(health)
	damaged.emit(get_parent(), attack.attack_damage)	# Goes (for now) to hit_state.
	
	if health <= 0 and character.has_method("death"):
		character.death()


# I don't know how this doesn't overlap or whatever, but I'll take it.
func _on_fire_duration_timer_timeout() -> void:
	on_fire = false
	#print("Timer timeout in _on_fire_duration_timer_timeout() in health_component.gd.")
