class_name Bullet3
extends Bullet

@export var area_of_effect_zone : Area2D
@export var shape : CollisionShape2D
var self_damage : bool = true
var player : PlayerClass


func _ready() -> void:
	# Getting the player as a variable.
	player = get_parent().get_parent().get_parent()
	# Getting the value of self_damage from player.
	self_damage = player.self_damage
	#print({"oui" : 1}.non)	# Crashes.


func _process(_delta) -> void:
	# Not sure if this is the right place, maybe should go in _ready(), but I can't really test right now.
	# It does.
#	self_damage = player.self_damage
	pass
#	print(self_damage)
#	print(get_parent().get_parent().get_parent())
#	print(area_of_effect_zone.get_overlapping_areas())


# Procedure that handles the damage in an AoE of the missile.
# As is, the enemy is hit twice: by the bullet itself, actually dealing 0 damage, and by the explosion.
func area_of_effect(collision_pos) -> void:
	# Create a new attack.
	var attack : Attack = Attack.new()
	# With the aoe damage as damage.
	attack.attack_damage = aoe_attack_damage
	
	
	# This version is an attempt at using shape-casting.
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
	
	
	# This is the "old" code, as in code using overlapping Area2D. It works but doesn't damage in a matrix.
	# This causes an issue where the explosion can damage twice or more, because it counts each area.
	# I need to check if it is the right one.
	area_of_effect_zone.monitoring = true
	for area in area_of_effect_zone.get_overlapping_areas():
		# Check if the area met is the hit box for AoE, so that it damages exactly once per attack.
		if area is AOEHitBox:
			var parent = area.get_parent()
			#print(area)
			# This does not work correctly, if it finds a Player it returns thus leaving the loop.
	#		if parent is Player:
	#			return
			# Instead, we can incorporate the if statement. This works, but I'd like to give the player
			# the choice of having or not self damage. This will be an option (self_damage).
			if self_damage or not parent is PlayerClass:
				
				
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
				
				
				for child in parent.get_children():
					if child is HealthComponent:
		#				print("bullet3: ", attack.attack_damage)
						child.damage(attack)
	
	
#	area_of_effect_zone.checking = true
#	print(area_of_effect_zone.get_overlapping_bodies())
#	print("hello3")
