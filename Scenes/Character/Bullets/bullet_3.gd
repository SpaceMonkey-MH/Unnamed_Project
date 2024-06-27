extends Bullet

class_name Bullet3


@export var area_of_effect_zone : Area2D


#func _process(delta):
#	print(area_of_effect_zone.get_overlapping_areas())


func area_of_effect():
	area_of_effect_zone.monitoring = true
	var attack = Attack.new()
	attack.attack_damage = aoe_attack_damage
	for area in area_of_effect_zone.get_overlapping_areas():
		var parent = area.get_parent()
		if parent is Player:
			return
		for child in parent.get_children():
			if child is HealthComponent:
#				print("bullet3: ", attack.attack_damage)
				child.damage(attack)
#	area_of_effect_zone.checking = true
#	print(area_of_effect_zone.get_overlapping_bodies())
#	print("hello3")
