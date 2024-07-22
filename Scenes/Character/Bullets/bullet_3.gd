class_name Bullet3
extends Bullet

# The older versions and their explanations can be found in old_bullet_3.gd.

# Whether or not the player can be damaged by the explosion.
var self_damage : bool = true
# The player as a variable, so we can get self_damage value from it. Should be replaced when options come out.
var player : PlayerClass
# The index of progression of the for loop setting the AoE shapes. Also, the minimum value of the AoE size.
# WARNING: If it is highier than aoe_size, the damage will not work as there will be no areas created.
var prog_index : int = 10
# The position of the tip of the missile.
var area_pos : Vector2 = Vector2(20, 0)


func _ready() -> void:
	# Getting the player as a variable.
	player = get_parent().get_parent().get_parent()
	# Getting the value of self_damage from player.
	self_damage = player.self_damage
	# The goal here is to create aoe_size / prog_index concentric CollisionShape2D inside the Area2D.
	# Actually, the goal is gonna be to create one Area2D per CollisionShape2D, all inside a Node.
	# We iterate over the maximum size of the AoE, in order to set the radius of the CollisionShape2D.
	for radius : int in range(prog_index, aoe_size + 1, prog_index):
		# New variable for the area.
		var aoe_area : Area2D = Area2D.new()
		# And for the cs.
		var aoe_collision_shape : CollisionShape2D = CollisionShape2D.new()
		# Set a circle as a shape of the cs.
		aoe_collision_shape.shape = CircleShape2D.new()
		# Set the radius of the circle to the iteration variable.
		aoe_collision_shape.shape.radius = radius
		# Adding the cs as a child of the area.
		aoe_area.add_child(aoe_collision_shape)
		# Repositioning so that it is on the tip of the missile.
		aoe_area.position = area_pos
		# Adding the area as a child of the main node, so that it "appears" on the missile.
		add_child(aoe_area)


# Procedure that handles the damage of the missile in an AoE.
# As is, the enemy is hit twice: by the bullet itself, actually dealing 0 damage, and by the explosion.
func area_of_effect() -> void:	
	# Create a new attack.
	var attack : Attack = Attack.new()
	# With the AoE damage as damage. What I want, is for it to be aoe_ad / times_hit.
	attack.attack_damage = aoe_attack_damage / (aoe_size / prog_index)
	# I separated the area-creating part from the damaging part for clarity and "wanting to try it before" reasons.
	for bullet_child : Node in get_children():
		if bullet_child is Area2D:
			bullet_child.monitoring = true
			# Get the overlapping bodies, and not the areas, because it is simpler that way.
			# This seems to be working.
			for overlapping_body : Node2D in bullet_child.get_overlapping_bodies():
				# Check if is not the player, or if self_damage is activated.
				if self_damage or not overlapping_body is PlayerClass:
					# Iterate over the children of the character (or tile map, but that doesn't really matter).
					for character_child : Node in overlapping_body.get_children():
						# If it is the damageable part of the character.
						if character_child is HealthComponent:
							# Damage it with the attack set up above.
							character_child.damage(attack)
							# Can't await timeout for some reason.

