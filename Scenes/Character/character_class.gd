class_name CharacterClass
extends CharacterBody2D

# Base class for the characters, that is to say the player and the enemies.

# HitBox as a variable, so that it can be disabled.
@export var hit_box: HitBoxClass
# I'm trying stuff with the visible on screen notifier, in oreder to properly queue free the characters when dead.
#@export var notifier = VisibleOnScreenNotifier2D
# The maximum health of the character.
@export var max_health: float = 100.0
# Timer before queue_free() when the dead characters fall out of the screen.
@export var out_of_screen_death_timer: float = 1.5
# Whether or not the character is out of screen. Used to queue free it when dead. Initialized here for placeholder
# but really set in _ready() in subclasses.
@export var out_of_screen: bool = false
# The amount of air penetration (1 - air resistance). Will be multiplied by the velocity of the character.
# Maybe this should be in level script, to be seen.
@export var air_penetration: float = 0.99
# Whether or not the character can use the blink ability defined below. Needed so that the sounds are loaded
# only when necessary. Has to be set manually, but should prevent from blinking if false.
@export var can_blink: bool = false
# The path to the folder with the sounds for the blink.
@export var blink_sound_path: String = "res://Assets/Sounds/Blink/"
# The maximum distance of the blink.
@export var blink_distance: float = 200.0
# The cool down of the blink.
@export var blink_cool_down_duration: float = 3.0
# The bar indicating if the blink is on or off cool down. I think it is easier to position if the position is
# exported, and then it takes less variables to just export the ReloadBar itself.
@export var blink_reload_bar: ReloadBar
# The shape cast used to check if the blink can be done (outside of a wall).
#@export var terrain_check_sc: ShapeCast2D
# No magic numbers. This is the time during which the death animation is supposedly played (this is just
# a placeholder).
var death_animation_timer: float = 1.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
# Whether or not the character is dead. I think this is useless? Maybe not.
var character_is_dead: bool = false
# Move speed of the character, here so it can be added to all the relative states. In pixels/second.
var move_speed: float = 0.0
# Whether or not the player can move, use for knockback.
var knocked_back: bool = false
# The Node that holds all the sound players for the blink.
var blink_sounds_node: Node
# The sound player currently playing.
var sound_playing_index: int = -1
# The area used to check if the blink target position is valid.
#var check_area: Area2D
# A list of bodies inside the check_area.
var body_array: Array = []
# Timer for the cool down of the blink.
var blink_cool_down_timer: Timer


func _ready():
	character_ready()
	if can_blink:
		blink_sounds_node = Node.new()
		blink_sounds_node.name = "BlinkSoundList"
		add_child(blink_sounds_node)
		create_stream_players(dir_contents(blink_sound_path))
		#print("blink_sounds_node in c_c.gd: ", blink_sounds_node)
		#print("Children of b_s_n in character_class.gd: ", blink_sounds_node.get_children())
		#for child in blink_sounds_node.get_children():
			#child.play()
		
		# This is to check the validity of the spot to which the character is blinking.
		# So, I am creating an area with a cs the shape of the hit box, at the position resulting of the movement.
		#check_area = Area2D.new()
		#var check_collision_shape: CollisionShape2D = CollisionShape2D.new()
		## I think this crashes if the character is not a rectangle.
		#var check_shape: RectangleShape2D = RectangleShape2D.new()
		#check_shape.size = hit_box.shape.size
		##check_shape.size = Vector2(1, 1)
		#check_collision_shape.shape = check_shape
		#check_area.add_child(check_collision_shape)
		#add_child(check_area)
		##check_area.monitoring = false
		#check_area.connect("body_entered", _on_check_area_body_entered)
		
		# Creating a Timer for the cool down of the blink.
		blink_cool_down_timer = Timer.new()
		blink_cool_down_timer.wait_time = blink_cool_down_duration
		blink_cool_down_timer.autostart = false
		blink_cool_down_timer.one_shot = true
		add_child(blink_cool_down_timer)
		blink_cool_down_timer.connect("timeout", _on_blink_cool_down_timer_timeout)
		
		if blink_reload_bar:
			# We multiply everything by 1000 so that it handles better the floats. The ratios sould stay the same.
			blink_reload_bar.set_max_value(blink_cool_down_duration * 1000)
			blink_reload_bar.update_value(blink_cool_down_duration * 1000)


# Reads path, and returns a list of the absolute paths to the .mp3 files in path.
func dir_contents(path: String) -> Array:
	var dir: DirAccess = DirAccess.open(path)
	var content_array: Array = []
	#print("dir: ", dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
				pass
			else:
				#print("Found file: " + file_name)
				if file_name.get_extension() == "mp3":
					content_array.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return content_array


func create_stream_players(audio_files: Array) -> void:
	for audio_file_name in audio_files:
		var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
		audio_stream_player.stream = load(blink_sound_path + audio_file_name)
		audio_stream_player.name = audio_file_name
		blink_sounds_node.add_child(audio_stream_player)
		#audio_stream_player.play()
		


# Creating a _process() procedure so that there can be code inside it and inside the functions in subclasses.
# This is useless for now.
func _process(delta: float) -> void:
#	print("Move speed of ", self, " from character_class.gd: ", move_speed)
	character_process(delta)
#	print("Hello from _physics_process in character_class.")
	# Doesn't seem to work. I Apparently cannot do this in superclass, idk.
	#print(notifier.is_on_screen())
	#if self is PlayerClass:
		#print("In c_c.gd (%s), blink_cool_down_timer.time_left: %s" % [self, blink_cool_down_timer.time_left])
	if blink_reload_bar and not can_blink:
		blink_reload_bar.update_value(-delta * 1000)


# Creating a _physics_process() procedure so that it regroups the test if the body is outside of the screen
# inside the superclass. This is useless for now.
func _physics_process(delta) -> void:
#	print("Move speed of ", self, " from character_class.gd: ", move_speed)
	character_physics_process(delta)
	# Simulate air resistance.
	velocity *= air_penetration
#	print("Hello from _physics_process in character_class.")


# Just a placeholder.
func character_ready():
	pass


# Just a placeholder.
func character_process(_delta) -> void:
	pass


# Just a placeholder.
func character_physics_process(_delta) -> void:
	pass


# Base function used for the death of the character, to be overwritten but useful if I forget to do so
# (or if I'm lazy). Or if it just works better that way, kind of like how the bullet
# _physics_process() function works.
func death() -> void:
#	print("Death of the character: ", self)
	# We need to deactivate the character node without freeing it, so that it doesn't interact too much anymore,
	# but it's still there for the damage label.
	deactivate_node()
	#print("deactivate_node() of ", self)
	character_is_dead = true
#	# This is temporary, it is used to simulate the animation.
#	# Also, should allow the damage label to exist on death.
#	# Actually, I have a better idea, let's put it in another function, and withdraw it when needed.
	# Actu-actually, it is useless now (see below), keeping just in case.
#	await wait()
#	# Calling the animation anyway.
#	death_animation()
#	# Freeing the queue (== death). It is better if it is after the character has exited the screen.
#	queue_free()
	# Changing the Z-index so that the character is visible when falling through the ground.
	z_index += 2
	## Trying to queue free when out of screen.
	#while not out_of_screen:
		## Passing the time to allow the character to fall out of the screen.
		#await get_tree().create_timer(0.1)
	#await get_tree().create_timer(out_of_screen_death_timer).timeout
	#queue_free()
	#print("queue_free() of ", self)
	if out_of_screen:
		handle_character_out_of_screen()
	


func deactivate_node() -> void:
	# Idk why, but it showed errors when killing that way, so I deferred it instead. Actually,
	# it doesn't work with deferred. IDK. Maybe I was using it wrong.
	hit_box.disabled = true


# This is used to wait before the node is queue-freed.
# This is a separate function so that it can be overwritten in extending classes.
# This doesn't work, and I don't know why...
# Ok now I know why, I had to await the call to wait() in death().
func wait() -> void:
#	print("Hello from wait() in character_class, before the await call.")
	await get_tree().create_timer(death_animation_timer).timeout
#	print("Hello from wait() in character_class, after the await call.")


# This is meant to be overwritten.
func death_animation() -> void:
	pass


# I think this is useless now, Idk.
# Procedure that handles what happens when a character is out of screen; called by the procedure connected
# to the VisibleOnScreenNotifier2D of the character.
func handle_character_out_of_screen() -> void:
	#if character_is_dead:
	await get_tree().create_timer(out_of_screen_death_timer).timeout
	queue_free()
	#print("queue_free() of ", self)


func knockback(source_pos: Vector2, mouse_pos: Vector2, knockback_force: float) -> void:
	knocked_back = true
	#print("character_class.gd: source_pos: %s, global_position: %s" % [source_pos, global_position])
	velocity += (mouse_pos - source_pos).normalized() * knockback_force
	#print("character_class.gd: velocity: ", velocity)
	move_and_slide()


func stop_knockback() -> void:
	knocked_back = false


# This teleports the character aver a short distance.
func blink(source_pos: Vector2, target_pos: Vector2) -> void:
	# This is to prevent issues, like if I forget to set can_blink to true for instance.
	if not can_blink:
		print("ERROR, the character cannot blink!")
		return
	# We teleport the character to the desired point (mouse position for instance) if that point is close by, or
	# else to a fixed distance in that direction.
	var movement: Vector2 = (target_pos - source_pos).normalized() * min(
		blink_distance, (target_pos - source_pos).length())
	
	# So, the issue is that, apparently, get_overlapping_bodies() happens before the change of position even
	# though it is supposed to be after, and I don't know why. Also the monitoring is weird.
	# My fix is to create a new area each time, and queue_free() it when a body enters, after adding the body
	# to an array. Then in here, we can check things and do the stuff we want.
	# Maybe this works better with a new variable each time.
	var check_area: Area2D = Area2D.new()
	var check_collision_shape: CollisionShape2D = CollisionShape2D.new()
	# I think this crashes if the character is not a rectangle.
	var check_shape: RectangleShape2D = RectangleShape2D.new()
	# I divide it by 5 to allow more flexibility, but this might lead to blinking into objects, Idk.
	check_shape.size = hit_box.shape.size / 5
	#check_shape.size = Vector2(1, 1)
	check_collision_shape.shape = check_shape
	check_area.add_child(check_collision_shape)
	check_area.name = "CheckArea"
	add_child(check_area)
	#check_area.monitoring = false
	check_area.connect("body_entered", _on_check_area_body_entered)
	
	# I think that what I want to do is to check if target_pos is in a clear spot, and if not, use move_and_slide
	# instead of teleport. This wont be perfect, but I think it will be good enough.
	check_area.global_position = source_pos + movement
	#check_area.global_position = target_pos
	#check_area.monitoring = true
	var time = Time.get_datetime_dict_from_system()
	#print("In c_c.gd: ", target_pos, source_pos + movement)
	#print("In c_c.gd, check_area.position is: ", check_area.global_position)
	#print("At: ", time.second, ". In c_c.gd, check_area collisions: ", check_area.get_overlapping_bodies())
	#check_area.monitoring = false
	# Apparently it needs to wait a bit.
	await get_tree().create_timer(0.05).timeout
	#print("At: ", time.second, ". In c_c.gd, body_array: ", body_array)
	
	if body_array.is_empty():
		global_position += movement
	else:
		##global_position += Vector2(0, -10)
		#velocity = movement# + Vector2(0, -100)
		#move_and_slide()
		# This is kinda ok, though it does stop if the target is too close to the ground, but I think that
		# would be too hard to get around.
		move_and_collide(movement)
	#velocity = movement.normalized() * 10000
	#move_and_slide()
	#move_and_collide(movement)
	
	play_sound()
	
	body_array.clear()
	
	can_blink = false
	blink_cool_down_timer.start()
	#await  get_tree().create_timer(5).timeout
	#print("In c_c.gd (%s), blink_cool_down_timer.wait_time: %s" % [self, blink_cool_down_timer.wait_time])
	
	#check_area.queue_free()
	#await get_tree().create_timer(0.05).timeout
	
	#check_area.global_position
	
	## I think that shape casting is not what I am looking for here.
	#var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	#var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	#query.set_shape(shape)
	###print("shape: %s, shape.shape: %s" % [shape, shape.shape])
	#print("In c_c.gd, query is %s, query.shape is %s." % [query, query.shape])
	#var result : Array[Dictionary] = space_state.intersect_shape(query)
	#print("result in c_c.gd: ", result)
	#var shape_cast: ShapeCast2D = ShapeCast2D.new()
	#shape_cast.shape = shape
	#shape_cast.name = "TerrainCheckShapeCast"
	#add_child(shape_cast)
	#print("In c_c.gd, collisions: ", shape_cast.is_colliding())
	#print("I c_c.gd, children: ", get_children())
	#terrain_check_sc.target_position = target_pos
	#print("In c_c.gd, collisions: ", terrain_check_sc.collision_result)


func play_sound():
	# Randomize the index of the sound player.
	var sound_index: int = randi_range(0, blink_sounds_node.get_child_count() - 1)
	# If this is the first sound played and there is more than 1 sounds to play.
	if sound_playing_index != -1 and blink_sounds_node.get_child_count() > 1:
		# While the new index is the same as the actual one.
		while sound_index == sound_playing_index:
			# Randomize again.
			sound_index = randi_range(0, blink_sounds_node.get_child_count() - 1)
	# Play the sound with the chosen index.
	blink_sounds_node.get_children()[sound_index].play()
	# Update the actual index.
	sound_playing_index = sound_index


# Connected to the signal of the areas created by code, for the blink.
# I don't know why it adds all the bodies to the array even though it should be queue_free(),
# but I'm not complaining. This kinda relies on magic.
func _on_check_area_body_entered(body: Node) -> void:
	#var time = Time.get_datetime_dict_from_system()
	#print("At: ", time.second, ". In c_c.gd, body is: ", body)
	body_array.append(body)
	if $CheckArea:
		$CheckArea.queue_free()


# Connected to the timeout() signal of the blink_cool_down_timer created by code.
func _on_blink_cool_down_timer_timeout() -> void:
	can_blink = true
	blink_reload_bar.update_value(blink_cool_down_duration * 1000)
