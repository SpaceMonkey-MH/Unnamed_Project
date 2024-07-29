extends Area2D

@export var fire_spitter_state : FireSpitterState


# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = false
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(monitoring)


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
