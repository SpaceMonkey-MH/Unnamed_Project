class_name RailgunProjectile
extends Bullet

# A list (array) of the characters already hit by the Railgun projectile.
var char_damaged: Array = []


func damage_through() -> void:
	var attack: Attack = Attack.new()
	attack.attack_damage = attack_damage
	for overlapping_body in area_2d.get_overlapping_bodies():
		if not overlapping_body in char_damaged and overlapping_body is EnemyClass:
			#print("overlapping_body in railgun_projectile.gd: ", overlapping_body)
			for node in overlapping_body.get_children():
				if node is HealthComponent:
					node.damage(attack)
					char_damaged.append(overlapping_body)
