extends Bullet


class_name Bullet3


@export var area_of_effect_zone : Area2D
var self_damage : bool = true
var player : CharacterBody2D


func _ready():
	player = get_parent().get_parent().get_parent()


func _process(_delta):
	self_damage = player.self_damage
#	print(self_damage)
#	print(get_parent().get_parent().get_parent())
#	print(area_of_effect_zone.get_overlapping_areas())


func area_of_effect():
	area_of_effect_zone.monitoring = true
	var attack = Attack.new()
	attack.attack_damage = aoe_attack_damage
	for area in area_of_effect_zone.get_overlapping_areas():
		var parent = area.get_parent()
		# This does not work correctly, if it finds a Player it returns thus leaving the loop.
#		if parent is Player:
#			return
		# Instead, we can incorporate the if statement. This works, but I'd like to give the player
		# the choice of having or not self damage.
		if not parent is Player or self_damage:
			for child in parent.get_children():
				if child is HealthComponent:
	#				print("bullet3: ", attack.attack_damage)
					child.damage(attack)
#	area_of_effect_zone.checking = true
#	print(area_of_effect_zone.get_overlapping_bodies())
#	print("hello3")
