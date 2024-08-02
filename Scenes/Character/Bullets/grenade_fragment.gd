class_name GrenadeFragment
extends Bullet

# The Area2D that represents the AoE as a variable.
@export var aoe_area : Area2D
# Same but for the CollisionShape2D, so that the radius can be modified.
# WARNING: need to change this if the shape is not a circle.
@export var aoe_c_s : CollisionShape2D
# How much the projectile penetrates the air (1 - air resistance). The x velocity is multiplied by that factor.
var air_penetration_factor : float = 0.99
# Get the gravity from the project settings to be synced with enemy character nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
# 200 is kind of a magic number here, but I don't really know why I need it anyway. It is to balance gravity.
# Maybe this should be in a global something.
var gravity_divider : float = 200
# The level node, so the burning ground can be instantiated.
# This actually is GrenadeLauncher.
#@onready var level : Object = get_parent()
# The player as a variable, so we can get self_damage value from it. Should be replaced when options come out.
#@onready var player : PlayerClass = level.get_node("Player")
#@onready var player : PlayerClass = get_parent().get_parent().get_parent()
# Whether or not the player can be damaged by the explosion. This also crashes. Let's do it in _ready().
#@onready var self_damage : bool = player.self_damage
var self_damage : bool


func _ready():
	#aoe_area.monitoring = false
	#print("grenade_frag_scene in fragmentation_grenade.gd: ", grenade_frag_scene)
	# Not what I want. Can't do circular instantiation.
	#var frag_grenade_scene_2 : Node = get_tree().current_scene
	#print("frag_grenade_scene_2 in fragmentation_grenade.gd: ", frag_grenade_scene_2)
	# Here because I can't override _ready() in superclass.
	# Not needed I think, as I want the fragments to explode on contact.
	#fuse_timer.wait_time = time_to_effect
	#fuse_timer.start()
	# WARNING: need to change this if the shape is not a circle.
	aoe_c_s.shape.radius = aoe_size
	#print("In grenade_fragment.gd: ", level)
	self_damage = player.self_damage


func apply_x_mod(x_velocity : float, _delta : float) -> float:
	#print("Hello from apply_x_mod() in napalm.gd. x_velocity: ", x_velocity)
	#print("gravity: ", gravity, "\ndelta: ", delta)
	return x_velocity * air_penetration_factor


func apply_y_mod(y_velocity : float, delta : float) -> float:
	return y_velocity + (gravity / gravity_divider) * delta


func area_of_effect() -> void:
	#print("Hello from aoe in gre frag code.")
	var attack : Attack = Attack.new()
	attack.attack_damage = aoe_attack_damage
	# For some reason, it doesn't work when it is set to false in _ready(). So, nwo, this is quite useless, but I
	# keep it just in case.
	aoe_area.monitoring = true
	#print("aoe_area.get_overlapping_bodies() in aoe in frag gre code: ", aoe_area.get_overlapping_bodies())
	#for overlapping_body : Node2D in aoe_area.get_overlapping_bodies():
		#print("body in aoe in frag gre code: ", overlapping_body)
	for overlapping_body : Node2D in aoe_area.get_overlapping_bodies():
		# Check if it is not the player, or if self_damage is activated.
		if self_damage or not overlapping_body is PlayerClass:
		#if not overlapping_body is PlayerClass:
			# Iterate over the children of the character (or tile map, but that doesn't really matter).
			for character_child : Node in overlapping_body.get_children():
				# If it is the damageable part of the character.
				if character_child is HealthComponent:
					# Damage it with the attack set up above.
					character_child.damage(attack)
					#print("aoe_attack_damage from aoe in gre frag code: ", aoe_attack_damage)
