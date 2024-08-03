extends Node

## I don't think this is how you use global variables and especially not load().
#var player: PlayerClass = load("res://Scenes/Character/Player/player.tscn")
var player : PlayerClass


#func _ready() -> void:
	#print("player.gd: ", player)
