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
			print("Hello from health setter in health_component.")
			health = value
#		print("Set health in HealthComponent in ", get_parent(), " to: ", health)

# Debug variable, used to execute code every second.
var t : float = 0.0


## Called when the node enters the scene tree for the first time.
#func _ready():
#	health = max_health


func _process(delta) -> void:
	t += delta
	if t >= 1:
		health += 10
		t = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack : Attack):
	health -= attack.attack_damage
	if character.has_method("take_damage"):
		character.take_damage()
#		print(health)
	damaged.emit(get_parent(), attack.attack_damage)	# Goes (for now) to hit_state.
	
	if health <= 0 and character.has_method("death"):
		character.death()
