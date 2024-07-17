extends CharacterClass


# BodySprite2D as a variable so it can be flipped and modulated.
@export var body_sprite_2d : ColorRect
# Flashing is when the player takes damage.
var flashing_color : Color = Color.BLACK
var flashing_time : float = 0.1
var aoe_size : float = 100.0
var minimum_character_size : float = 40.0
# Used to execute code every second.
var nb_it : float = 0


#func _ready():
	#print("Original vector: %s\nVector rotated by 0: %s" % [Vector2(100, 100), Vector2(100, 100).rotated(PI)])


# This is Ray Casting.
# Cf: https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
func _physics_process(delta):
	#print(delta)
	nb_it += delta
	#print(nb_it)
	
	# Version 2.
	var vector_to_target : Vector2 = Vector2(aoe_size, 0)
	var rotation_angle : float = 2 * asin(minimum_character_size / (2 * aoe_size))
	var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	# Here, I'm not sure if it's better to use a single variable rotated by a bit each time,
	# or redeclare the variable each time
	for angle in range(0, floor(2 * PI * 100)):
		#print(angle)
		# We only need to rotate the translation vector, not the position one.
		vector_to_target = vector_to_target.rotated(rotation_angle)
		var target_position = global_position + vector_to_target
		var query = PhysicsRayQueryParameters2D.create(global_position, target_position)
		query.exclude = [self]
		var _result = space_state.intersect_ray(query)
		#if result and not result.collider is TileMap:
			#if nb_it >= 1:
				#print("Ray-casting result: ", result.collider)
	#if nb_it >= 1:
		#nb_it = 0
		#var time : Dictionary = Time.get_datetime_dict_from_system()
		##print("time: ", time.second)
	
	# Version 1.
	##print(global_position)
	#var space_state = get_world_2d().direct_space_state
	## Here, I'm not sure if it's better to use a single variable rotated by a bit each time,
	## or redeclare the variable each time
	#for angle in range(0, floor(2 * PI * 100)):
		##print(angle)
		## We only need to rotate the translation vector, not the position one.
		#var vector_to_target = Vector2(100, 0).rotated(angle / 100)
		#var target_position = global_position - vector_to_target
		##print(target_position.rotate(angle))
		##target_position = target_position.rotated(angle / 100)
		#var query = PhysicsRayQueryParameters2D.create(global_position, target_position)
		#query.exclude = [self]
		#var result = space_state.intersect_ray(query)
		#if result and not result.collider is TileMap:
			#print("Ray-casting result: ", result)


# Called by health_component I think.
func take_damage():
#	print(body_sprite_2d)
	body_sprite_2d.modulate = flashing_color
#	print("hello")
	await get_tree().create_timer(flashing_time).timeout
	body_sprite_2d.modulate = Color.WHITE

