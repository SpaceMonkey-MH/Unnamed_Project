class_name SoundBlasterState
extends WeaponsState

@export var cd_timer: Timer
@export var next_weapon_state: MeleeWeaponState
@export var previous_weapon_state: RailgunState
@export var sound_blaster_area: Area2D
@export var sound_list: Node
@export var attack_damage: float = 10.0
@export var reload_time: float = 0.2
@export var knockback_force: float = 10.0
@export var sound_path: String = "res://Assets/Sounds/SoundBlaster/Original"

# A variable to store whether or not the fire button is pressed. This is used to go around the fact that
# _unhandled_input() doesn't do continuous input (click hold is just a click).
var fire_pressed : bool = false


func _ready() -> void:
	cd_timer.wait_time = reload_time
	#print("dir_content: ", dir_contents(sound_path))
	create_stream_players(dir_contents(sound_path))


# Reads path, and returns a list of the absolute paths to the .mp3 files in path.
func dir_contents(path):
	var dir: DirAccess = DirAccess.open(path)
	var content_array: Array = []
	#print("dir: ", dir)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if file_name.get_extension() == "mp3":
					content_array.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return content_array


func create_stream_players(audio_files: Array) -> void:
	for audio_file_name in audio_files:
		var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
		audio_stream_player.stream = load(sound_path + audio_file_name)
		audio_stream_player.name = audio_file_name
		sound_list.add_child(audio_stream_player)


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
		fire_pressed = false
		sound_blaster_area.toggle_visible()
			


# Called when the current_state becomes this state.
func on_enter() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	cd_timer.paused = false


# Called when the next_state becomes another.
func on_exit() -> void:
	# This is so that the player can't reload a weapon that is not "equipped".
	cd_timer.paused = true


func play_sound():
	print("Sound list children: ", sound_list.get_children())
	var sound_index: int = randi_range(0, sound_list.get_child_count() - 1)
	sound_list.get_children()[sound_index].play()


func _on_sound_blaster_cool_down_timeout() -> void:
	can_fire = true
#	print("hello2")
