extends Area2D

# We'll need to access some of its variables.
@export var sound_blaster_state: SoundBlasterState
@export var sound_blaster_sprite : Sprite2D
# Need to try to see if this is of any use.
@export var sound_blaster_hit_box : CollisionPolygon2D
var crazy_game: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = false
	sound_blaster_sprite.visible = false
	# I think this is useless, but it might be useful so I keep it just in case.
	sound_blaster_hit_box.visible = false
	crazy_game = PlayerVariables.player.crazy_game


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(monitoring)

# Might be just a placeholder, as with animations I just have to display an empty sprite.
func toggle_visible():
	#print("Hello from toggle_visible() in fire_spitter_weapon.gd.")
	sound_blaster_sprite.visible = !sound_blaster_sprite.visible


func _on_body_entered(body: Node):
	#print("body in s_b_a.gd: ", body)
	# Could this be an easter egg that the Sound Blaster does self damage and self knockback?
	if body is PlayerClass and not crazy_game:
		return
	#print("Body entered: ", body)
	var attack = Attack.new()
	attack.attack_damage = sound_blaster_state.attack_damage
	for child in body.get_children():
		if child is HealthComponent:
			# Deferring the call otherwise it doesn't work with the collision shape or smth.
			child.call_deferred("damage", attack)
			#child.set_on_fire(sound_blaster_state.fire_duration, sound_blaster_state.fire_damage)
	if body is CharacterClass:
		body.knockback(global_position, get_global_mouse_position(), sound_blaster_state.knockback_force)
		await get_tree().create_timer(2).timeout
		body.stop_knockback()
