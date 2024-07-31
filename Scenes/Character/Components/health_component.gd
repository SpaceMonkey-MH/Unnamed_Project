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
## The wait time of that timer.
#@export var on_fire_wait_time : float = 5.0
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

# Debug variable, used to execute code every second.
var t : float = 0.0
# Whether or not the character is on fire.
var on_fire : bool = false
# The value of the fire damage, which will be applied to health.
var fire_damage : float = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	#print("Hello from health_component.gd with parent: ", get_parent())
	#print("Health Component Timer: ", on_fire_timer)
	# Just here to simulate a call.
	#set_on_fire(2.0, 10.0)
	#on_fire_timer.wait_time = on_fire_wait_time
	pass


func _process(delta) -> void:
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
		health += 1
		t = 0.0


# Should be a function that handles the setting target on fire part, taking a duration and a damage for the burn.
# I don't know how this doesn't overlap or whatever, but I'll take it.
func set_on_fire(fire_duration : float = 5.0, f_damage : float = 10.0):
	on_fire_timer.wait_time = fire_duration
	on_fire_timer.start()
	fire_damage = f_damage
	on_fire = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack : Attack = Attack.new()):
	health -= attack.attack_damage
	if character.has_method("take_damage"):
		character.take_damage()
#		print(health)
	damaged.emit(get_parent(), attack.attack_damage)	# Goes (for now) to hit_state.
	
	if health <= 0 and character.has_method("death"):
		character.death()


# I don't know how this doesn't overlap or whatever, but I'll take it.
func _on_fire_duration_timer_timeout():
	on_fire = false
