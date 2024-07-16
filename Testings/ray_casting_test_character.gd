extends CharacterBody2D


#func _ready():
	#print("Original vector: %s\nVector rotated by 0: %s" % [Vector2(100, 100), Vector2(100, 100).rotated(PI)])


# Cf: https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
#func _physics_process(_delta):
	##print(global_position)
	#var space_state = get_world_2d().direct_space_state
	## Here, I'm not sure if it's better to use a single variable rotated by a bit each time,
	## or redeclare the variable each time
	#for angle in range(0, floor(2 * PI * 100)):
		##print(angle)
		# We only need to rotate the translation vector, not the position one.
		#var vector_to_target = Vector2(100, 0).rotated(angle / 100)
		#var target_position = global_position - vector_to_target
		##print(target_position.rotate(angle))
		##target_position = target_position.rotated(angle / 100)
		#var query = PhysicsRayQueryParameters2D.create(global_position, target_position)
		#query.exclude = [self]
		#var result = space_state.intersect_ray(query)
		#if result and not result.collider is TileMap:
			#print("Ray-casting result: ", result)

