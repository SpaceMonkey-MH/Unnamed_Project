# I don't remember what this script is for, but I'm gonna leave it here anyway.

extends Area2D

@export var bullet : CharacterBody2D

#
#var checking : bool = true

# Called when the node enters the scene tree for the first time.
#func _ready():
#	monitoring = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Not used for the explosion aoe I think.
#func _process(delta):
#	var attack = Attack.new()
#	attack.attack_damage = bullet.attack_damage
#	for area in get_overlapping_areas():
#		var parent = area.get_parent()
#		if parent is Player:
#			return
#		for child in parent.get_children():
#			if child is HitBoxComponent:
#				child.damage(attack)
	
#	print(monitoring)

#
#func _on_body_entered(body):
#	return
##	if not checking:
##		return
##	print(body)
#	var attack = Attack.new()
#	attack.attack_damage = bullet.attack_damage
#	if body is Player:
#		return
#	for child in body.get_children():
#		if child is HitBoxComponent:
#			child.damage(attack)
