class_name Bullet3
extends Bullet

@export var area_of_effect_zone : Area2D
var self_damage : bool = true
var player : PlayerClass


func _ready() -> void:
	# Getting the player as a variable.
	player = get_parent().get_parent().get_parent()
	# Getting the value of self_damage from player.
	self_damage = player.self_damage


func _process(_delta) -> void:
	# Not sure if this is the right place, maybe should go in _ready(), but I can't really test right now.
	# It does.
#	self_damage = player.self_damage
	pass
#	print(self_damage)
#	print(get_parent().get_parent().get_parent())
#	print(area_of_effect_zone.get_overlapping_areas())


# Procedure that handles the damage in an AoE of the missile.
func area_of_effect() -> void:
	area_of_effect_zone.monitoring = true
	var attack = Attack.new()
	attack.attack_damage = aoe_attack_damage
	# This causes an issue where the explosion can damage twice or more, because it counts each area.
	# I need to check if it is the right one.
	for area in area_of_effect_zone.get_overlapping_areas():
		# Check if the area met is the hit box for AoE.
		if area is AOEHitBox:
			var parent = area.get_parent()
			#print(area)
			# This does not work correctly, if it finds a Player it returns thus leaving the loop.
	#		if parent is Player:
	#			return
			# Instead, we can incorporate the if statement. This works, but I'd like to give the player
			# the choice of having or not self damage. This will be an option.
			if not parent is PlayerClass or self_damage:
				for child in parent.get_children():
					if child is HealthComponent:
		#				print("bullet3: ", attack.attack_damage)
						child.damage(attack)
#	area_of_effect_zone.checking = true
#	print(area_of_effect_zone.get_overlapping_bodies())
#	print("hello3")
