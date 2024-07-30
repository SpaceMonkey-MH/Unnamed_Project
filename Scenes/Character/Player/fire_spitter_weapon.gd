extends Area2D

@export var fire_spitter_state : FireSpitterState
@export var fire_spitter_sprite : Sprite2D
@export var fire_spitter_hit_box : CollisionPolygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = false
	fire_spitter_sprite.visible = false
	# I think this is useless, but it might be useful so I keep it just in case.
	fire_spitter_hit_box.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(monitoring)

# Might be just a placeholder, as with animations I just have to display an empty sprite.
func toggle_visible():
	#print("Hello from toggle_visible() in fire_spitter_weapon.gd.")
	fire_spitter_sprite.visible = !fire_spitter_sprite.visible


func _on_body_entered(body):
	# Could this be an easter egg that the fire spitter does self damage?
	if body is PlayerClass:
		return
	#print("Body entered: ", body)
	var attack = Attack.new()
	attack.attack_damage = fire_spitter_state.attack_damage
	for child in body.get_children():
		if child is HealthComponent:
			# Deferring the call otherwise it doesn't work with the collision shape or smth.
			child.call_deferred("damage", attack)
			child.set_on_fire(fire_spitter_state.fire_duration, fire_spitter_state.fire_damage)
