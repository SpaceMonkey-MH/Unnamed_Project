class_name SoundBlasterState
extends WeaponsState

@export var cd_timer: Timer
@export var next_weapon_state: MeleeWeaponState
@export var previous_weapon_state: RailgunState
@export var sound_blaster_area: Area2D
@export var sound_list: Node
@export var attack_damage: float = 10.0
@export var reload_time: float = 0.2
@export var knockback_force: float = 200.0
@export var sound_path: String = "res://Assets/Sounds/SoundBlaster/Usable/"
# A variable to store whether or not the fire button is pressed. This is used to go around the fact that
# _unhandled_input() doesn't do continuous input (click hold is just a click).
var fire_pressed: bool = false
# The sound player currently playing.
var sound_playing_index: int = -1


func _ready() -> void:
	cd_timer.wait_time = reload_time
	#print("dir_content: ", dir_contents(sound_path))
	create_stream_players(dir_contents(sound_path))
	#print("sound_playing_index in sound_blaster.gd: ", sound_playing_index)


# Reads path, and returns a list of the absolute paths to the .mp3 files in path.
func dir_contents(path: String):
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
		#print("audio_file_name in sound_blaster.gd: ", audio_file_name)
		var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
		audio_stream_player.stream = load(sound_path + audio_file_name)
		#audio_stream_player.stream = load(
			#"res://Assets/Sounds/SoundBlaster/Original/aggressive-metal-sinister-111839.mp3")
		audio_stream_player.name = audio_file_name
		audio_stream_player.connect("finished", _on_sound_blaster_player_finished)
		sound_list.add_child(audio_stream_player)
		#print("audio_stream_player.stream in sound_blaster.gd: ", audio_stream_player.stream)


func state_process(_delta: float) -> void:
	#if Input.is_action_pressed("fire") and can_fire:
		#weapon_fire(character.position, character.get_global_mouse_position(), bullet_2_scene,
			#attack_damage, speed_factor)
		#can_fire = false
		#timer.start()
		#print("mg.gd: ", get_parent().get_parent(), "\n", character)
		#pass
	if fire_pressed and can_fire:
		sound_blaster_area.monitoring = true
		can_fire = false
		cd_timer.start()
		await get_tree().create_timer(0.05).timeout
		sound_blaster_area.monitoring = false
		#print("Fire in sound_blaster.gd.")


func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("next_weapon"):
		next_state = next_weapon_state
	if event.is_action_pressed("previous_weapon"):
		next_state = previous_weapon_state
	# This does not work here, event is only the new ones, not continuous. Trying to go around that.
	# Someone online said I sould add a true argument to is_action_pressed(), but it doesn't work here idk.
	#if event.is_action_pressed("fire") and can_fire:
		#print("Fired in state_input() in weapon2.gd.")
		#weapon_fire(get_parent().get_parent().position, character.get_global_mouse_position(), bullet_2_scene,
			#attack_damage, speed_factor)
		#can_fire = false
		#timer.start()
	# Testing something.
	if event.is_action_pressed("fire"):
		fire_pressed = true
		sound_blaster_area.toggle_visible()
		play_sound()
		#$SoundList/SoundBlasterSound1.play()
	if event.is_action_released("fire"):
		if fire_pressed:
			fire_pressed = false
			sound_blaster_area.toggle_visible()
		sound_list.get_children()[sound_playing_index].stop()


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	cd_timer.paused = false


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	cd_timer.paused = true
	if fire_pressed:
		fire_pressed = false
		sound_blaster_area.toggle_visible()
		sound_list.get_children()[sound_playing_index].stop()


func play_sound():
	#print("Sound list children: ", sound_list.get_children())
	# Randomize the index of the sound player.
	var sound_index: int = randi_range(0, sound_list.get_child_count() - 1)
	#print("sound_blaster.gd: sound_index: %s, sound_playing_index: %s" % [
		#sound_index, sound_playing_index])
	# If this is the first sound played and there is more than 1 sounds to play.
	if sound_playing_index != -1 and sound_list.get_child_count() > 1:
		# While the new index is the same as the actual one.
		while sound_index == sound_playing_index:
			#print("sound_blaster.gd: sound_index: %s, sound_playing_index: %s" % [
				#sound_index, sound_playing_index])
			# Randomize again.
			sound_index = randi_range(0, sound_list.get_child_count() - 1)
	# Play the sound with the chosen index.
	sound_list.get_children()[sound_index].play()
	# Update the actual index.
	sound_playing_index = sound_index


func _on_sound_blaster_cool_down_timeout() -> void:
	can_fire = true
#	print("hello2")
	# Flash the sprite. Maybe to be removed when there is a real animation.
	if fire_pressed:
		sound_blaster_area.toggle_visible()
		await get_tree().create_timer(0.05).timeout
		sound_blaster_area.toggle_visible()


func _on_sound_blaster_player_finished():
	#print("Hello from sound_blaster.gd.")
	sound_list.get_children()[sound_playing_index].play()
