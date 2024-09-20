extends Area2D

@export var melee_weapon_state : MeleeWeaponState


# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(monitoring)


func _on_body_entered(body):
	# Could this be an easter egg that the melee weapon does self damage?
	if body is PlayerClass:
		return
	#print("_on_body_entered() in m_w.gd.")
#	print("Body entered: ", body)
	var attack = Attack.new()
	#print("attack: ", attack, "\nmelee_weapon_state: ", melee_weapon_state)
	attack.attack_damage = melee_weapon_state.attack_damage
	for child in body.get_children():
		if child is HealthComponent:
#			print("call_deferred(\"child.damage\", attack)")
			# IT WORKS! I just had to not be an idiot!
			print("_on_body_entered() in m_w.gd.")
			child.call_deferred("damage", attack)
#			child.damage(attack)
