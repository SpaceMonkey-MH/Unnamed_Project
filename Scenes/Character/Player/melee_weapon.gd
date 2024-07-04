extends Area2D

@export var melee_weapon_state : MeleeWeaponState


# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(monitoring)


func _on_body_entered(body):
	print("Body entered: ", body)
	var attack = Attack.new()
	attack.attack_damage = melee_weapon_state.attack_damage
	# Could this be an easter egg that the melee weapon does self damage?
	if body is Player:
		return
	for child in body.get_children():
		if child is HealthComponent:
#			print("call_deferred(\"child.damage\", attack)")
			# IT WORKS! I just had to not be an idiot!
			child.call_deferred("damage", attack)
#			child.damage(attack)
