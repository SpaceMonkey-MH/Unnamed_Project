extends Area2D

# We'll need to access some of its variables.
@export var sound_blaster_state: SoundBlasterState
@export var sound_blaster_sprite : Sprite2D
@export var sound_blaster_hit_box : CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = false
	sound_blaster_sprite.visible = false
	# I think this is useless, but it might be useful so I keep it just in case.
	sound_blaster_hit_box.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(monitoring)

# Might be just a placeholder, as with animations I just have to display an empty sprite.
func toggle_visible():
	#print("Hello from toggle_visible() in fire_spitter_weapon.gd.")
	sound_blaster_sprite.visible = !sound_blaster_sprite.visible


func _on_body_entered(body):
	# Could this be an easter egg that the fire spitter does self damage?
	if body is PlayerClass:
		return
	#print("Body entered: ", body)
	var attack = Attack.new()
	attack.attack_damage = sound_blaster_state.attack_damage
	for child in body.get_children():
		if child is HealthComponent:
			# Deferring the call otherwise it doesn't work with the collision shape or smth.
			child.call_deferred("damage", attack)
			#child.set_on_fire(sound_blaster_state.fire_duration, sound_blaster_state.fire_damage)
