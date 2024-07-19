class_name Bullet3
extends Bullet

# The older versions and their explanations can be found in old_bullet_3.gd.

# The Area2D that represents the AoE as a variable.
@export var aoe_area : Area2D
# Whether or not the player can be damaged by the explosion.
var self_damage : bool = true
# The player as a variable, so we can get self_damage value from it. Should be replaced when options come out.
var player : PlayerClass
# The index of progression of the for loop setting the AoE shapes. Also, the minimum value of the AoE size.
# WARNING: If it is highier than aoe_size, the damage will not work as there will be no areas created.
var prog_index : int = 10


func _ready() -> void:
	# Getting the player as a variable.
	player = get_parent().get_parent().get_parent()
	# Getting the value of self_damage from player.
	self_damage = player.self_damage


# Procedure that handles the damage of the missile in an AoE.
# As is, the enemy is hit twice: by the bullet itself, actually dealing 0 damage, and by the explosion.
func area_of_effect() -> void:
	# Create a new attack.
	var attack : Attack = Attack.new()
	# With the AoE damage as damage. What I want, is for it to be aoe_ad / times_hit.
	attack.attack_damage = aoe_attack_damage / (aoe_size / prog_index)
	print("attack.attack_damage: ", attack.attack_damage)
	# The goal here is to create aoe_size / prog_index concentric CollisionShape2D inside the Area2D.
	# Actually, the goal is gonna be to create one Area2D per CollisionShape2D, all inside a Node.
	for radius : int in range(prog_index, aoe_size + 1, prog_index):
		var aoe_collision_shape : CollisionShape2D = CollisionShape2D.new()
		aoe_collision_shape.shape = CircleShape2D.new()
		aoe_collision_shape.shape.radius = radius
		print("aoe_collision_shape.shape.radius: ", aoe_collision_shape.shape.radius)
		aoe_area.add_child(aoe_collision_shape)
	print("aoe_area children:", aoe_area.get_children())

