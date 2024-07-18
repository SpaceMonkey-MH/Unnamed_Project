class_name Bullet3
extends Bullet

# The Area2D that represents the AoE as a variable.
@export var area_of_effect_2d : Area2D
# The CollisionShape2D that represents the AoE as a variable.
@export var area_of_effect_zone : CollisionShape2D
# Used for shape-casting version.
#@export var shape : CollisionShape2D
var self_damage : bool = true
var player : PlayerClass


func _ready() -> void:
	# Getting the player as a variable.
	player = get_parent().get_parent().get_parent()
	# Getting the value of self_damage from player.
	self_damage = player.self_damage
	#print({"oui" : 1}.non)	# Crashes.
	#print({}.non)	# Also crashes.


func _process(_delta) -> void:
	# Not sure if this is the right place, maybe should go in _ready(), but I can't really test right now.
	# It does.
#	self_damage = player.self_damage
	pass
#	print(self_damage)
#	print(get_parent().get_parent().get_parent())
#	print(area_of_effect_2d.get_overlapping_areas())


# Procedure that handles the damage in an AoE of the missile.
# As is, the enemy is hit twice: by the bullet itself, actually dealing 0 damage, and by the explosion.
func area_of_effect(_collision_pos) -> void:
	# Create a new attack.
	var attack : Attack = Attack.new()
	# With the aoe damage as damage.
	#attack.attack_damage = aoe_attack_damage
	
	
	# This version is an attempt at using shape-casting. This is not working, fml.
	#var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	#var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	#query.set_shape(shape.shape)
	#print("shape: %s, shape.shape: %s" % [shape, shape.shape])
	#print("query: ",query)
	#var result : Array[Dictionary] = space_state.intersect_shape(query, 1)
	#print("result: ", result)
	
	
	# This version is an attempt at using ray-casting, it kinda works but not great.
	#var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	## Here, I'm not sure if it's better to use a single variable rotated by a bit each time,
	## or redeclare the variable each time. I (Julien) think(s) I should use a single variable (first option).
	#var vector_to_target : Vector2 = Vector2(aoe_size, 0)
	#var rotation_angle : float = 2 * asin(minimum_character_size / (2 * aoe_size))
	## According to my findings, the angle I'm looking for (the rotation angle for the ray-cast, that is to say
	## the rate at which the ray-cast will be checking) is (for a ray length of L and a character size of l
	## (chord)): theta = 2 * arcsin(l / 2 * L).
	## It seems a little high, idk (so, the angle is big, and the number or rays is low).
	#for angle : float in range(0, ceil((2 * PI) / rotation_angle)):
		##print("rotation_angle: ", rotation_angle)
		##print(angle)
		## We only need to rotate the translation vector, not the position one.
		#vector_to_target = vector_to_target.rotated(rotation_angle)
		#var target_position : Vector2 = global_position + vector_to_target
		##print("target_position: ", target_position)
		##print(target_position.rotate(angle))
		##target_position = target_position.rotated(angle / 100)
		#var query : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position,
																					#target_position)
		#query.exclude = [self]
		#var result : Dictionary = space_state.intersect_ray(query)
		#if result:
			#var collider = result.collider
			##print("collider.get_children(): ", collider.get_children())
			##print("Ray-casting result: ", result)
			#if self_damage or not collider is PlayerClass:
				#for child in collider.get_children():
					#if child is HealthComponent:
		##				print("bullet3: ", attack.attack_damage)
						#child.damage(attack)
	
	
	# This version is with area overlapping (nova), and should include "matrix" damage, finally!
	area_of_effect_2d.monitoring = true
	# A dictionary of {character_hit : hit_point}. This is actually useless, I need an array instead.
	#var hit_dictionary :  Dictionary = {}
	# An array of the characters already hit, so that they are excepted from the future damage.
	var hit_array : Array = []
	# We iterate on the size of the aoe, to have the nova (expanding damaging area).
	for size in range(1, aoe_size + 1):
		# - Try this: 
		# - ad = (aoe_ad / size) * (aoe_size / aoe_ad): (size = 1): (40 / 1) * (80 / 40) = 40 (actually, 80)
		# and (size = 80): (40 / 80) * (80 / 40) = 1, this seems fine (nope)!
		# - Or, ad = (aoe_ad / size) * (aoe_size / size): (size = 1): (40 / 1) * (80 / 1) = 3200,
		# (size = 80): (40 / 80) * (80 / 80) = 0.5. This is not it.
		# Nope.
		#print("size: ", size, "\n aoe_attack_damage: ", aoe_attack_damage / (
									#aoe_attack_damage / (aoe_size / size)))
		# Maybe. Nope.
		#print("size: ", size, "\n aoe_attack_damage: ", (aoe_attack_damage / size) * (
			#aoe_size / aoe_attack_damage))
		# Nope. Fuck it, see below.
		#print("size: ", size, "\n aoe_attack_damage: ", (aoe_attack_damage / size) * (
			#aoe_attack_damage / aoe_size))
		#attack.attack_damage = aoe_attack_damage - size / (aoe_size / aoe_attack_damage)
		#print(size, "\n", attack.attack_damage)
		#print(hit_dictionary)
		area_of_effect_zone.shape.radius = size
		#print(area_of_effect_zone.shape.radius)
		for area : Area2D in area_of_effect_2d.get_overlapping_areas():
			print("area_of_effect_zone.shape.radius: ", area_of_effect_zone.shape.radius)
			# Check if the area met is the hit box for AoE, so that it damages exactly once per attack.
			if area is AOEHitBox:
				var parent : CharacterClass = area.get_parent()
				#print(parent)
				#print(area)
				# This does not work correctly, if it finds a Player it returns thus leaving the loop.
		#		if parent is Player:
		#			return
				# Instead, we can incorporate the if statement. This works, but I'd like to give the player
				# the choice of having or not self damage. This will be an option (self_damage).
				# Also, we have except the characters already damaged.
				if not parent in hit_array and (self_damage or not parent is PlayerClass):
					
					
					# This may be used some day, it was an attempt at damaging in a matrix.
					## The distance between the collision (explosion) and the receiver. This is from the center.
					#var dist_to_explosion = (collision_pos - parent.position).length()
					##print("dist_to_explosion: ", dist_to_explosion)
					## This should crash if the hit box is not a rectangle.
					##print('parent.get_node("HitBox").shape.size: ', parent.get_node("HitBox").shape.size)
					#var parent_shape = parent.get_node("HitBox").shape
					#var parent_size
					##push_error("Oui")
					##print("parent_shape: ", parent_shape)
					#if parent_shape is RectangleShape2D:
						#
					
					# For each node (maybe this isn't node, idk) child to parent.
					for child : Node in parent.get_children():
						#print(child)
						# If the child is a HealthComponent, meaning the damageable part of the character.
						if child is HealthComponent:
			#				print("bullet3: ", attack.attack_damage)
							#if size == 0:
								#attack.attack_damage = aoe_attack_damage
							#else:
								## So, I need to have the following: when size is 1, ad must be aoe_ad,
								## but when size is aoe_size, ad must be 1. I can't find it (see above),
								## I'll do an ugly loop instead.
								#attack.attack_damage = aoe_attack_damage / (
									#aoe_attack_damage / (size / aoe_size))
							## Ugly array and loop to compute the attack.attack_damage.
							# Actually I don't need that.
							#var array : Array = []
							#for i in range(aoe_size + 1):
								## aoe_attack_damage - i / (aoe_size / aoe_attack_damage)
								## (i = 0) (we want 40): 40 - 0 / (80 / 40) = 40
								## (i = 1) (we want something like 39.5): 40 - 1 / 2 = 39.5
								## (i = 80 (we want 0): 40 - 80 / (80 / 40) = 0
								## (aoe_size = 100, i = 1) (we want 39.6): 40 - 1 / (100 / 40) = 39.6
								## (aoe_ad = 80, i = 1) (we want 79): 80 - 1 / (80 / 80) = 79
								#array.append(aoe_attack_damage - )
							# This is my beaucoup attempt at this, but this time it should work.
							# So, I need to have the following: when size is 1, ad must be aoe_ad,
							# but when size is aoe_size, ad must be 1. This works!
							attack.attack_damage = aoe_attack_damage - size / (aoe_size / aoe_attack_damage)
							# This works! Except for the actual AoE part ofc xd.
							print("size: ", size, "\nattack.attack_damage: ", attack.attack_damage)
							# We damage the child, thus the parent.
							child.damage(attack)
							# What I need is to get the point on the line from self to parent, that is at size
							# distance to self. I need vectors for that. No, I actually don't need this point,
							# the distance is all I need.
							#var vector_to_parent : Vector2 = parent.position - self.position
							##print(vector_to_parent)
							#var vector_to_hit_point : Vector2 = vector_to_parent
							# We add the parent to the exception array.
							hit_array.append(parent)
							# We fill the dictionary up, using the parent hit and the location of the contact.
							#hit_dictionary[parent] = parent.position
	
	
	# This is the "old" code, as in code using overlapping Area2D. It works but doesn't damage in a "matrix".
	# This causes an issue where the explosion can damage twice or more, because it counts each area.
	# I need to check if it is the right one.
	#area_of_effect_2d.monitoring = true
	#for area in area_of_effect_2d.get_overlapping_areas():
		## Check if the area met is the hit box for AoE, so that it damages exactly once per attack.
		#if area is AOEHitBox:
			#var parent = area.get_parent()
			##print(area)
			## This does not work correctly, if it finds a Player it returns thus leaving the loop.
	##		if parent is Player:
	##			return
			## Instead, we can incorporate the if statement. This works, but I'd like to give the player
			## the choice of having or not self damage. This will be an option (self_damage).
			#if self_damage or not parent is PlayerClass:
				#
				#
				## This may be used some day, it was an attempt at damaging in a matrix.
				### The distance between the collision (explosion) and the receiver. This is from the center.
				##var dist_to_explosion = (collision_pos - parent.position).length()
				###print("dist_to_explosion: ", dist_to_explosion)
				### This should crash if the hit box is not a rectangle.
				###print('parent.get_node("HitBox").shape.size: ', parent.get_node("HitBox").shape.size)
				##var parent_shape = parent.get_node("HitBox").shape
				##var parent_size
				###push_error("Oui")
				###print("parent_shape: ", parent_shape)
				##if parent_shape is RectangleShape2D:
					##
				#
				#
				#for child in parent.get_children():
					#if child is HealthComponent:
		##				print("bullet3: ", attack.attack_damage)
						#child.damage(attack)
	
	
#	area_of_effect_2d.checking = true
#	print(area_of_effect_2d.get_overlapping_bodies())
#	print("hello3")
