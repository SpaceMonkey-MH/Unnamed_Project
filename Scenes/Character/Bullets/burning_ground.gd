extends Area2D

@export var fire_duration_timer : Timer
@export var burn_check_timer : Timer
# The time for which the ground burns. In seconds.
@export var ground_fire_duration : float = 5.0
# The time between two checks if there is something inside the area. In seconds.
@export var burn_check_rate :  float = 1.0
# The damage inflicted each tick (second) by the burning.
@export var burn_damage : float = 10.0
# The amount of time the target will burn. In seconds.
@export var burn_time : float = 5.0
# Whether or not the player can be damaged by the flames.
var self_damage : bool = true
# The player as a variable, so we can get self_damage value from it. Should be replaced when options come out.
var player : PlayerClass


func _ready():
	# Not sure how to get the player. Let's say I leave it like that, and we'll see when the options arrive.
	# Getting the player as a variable.
	#player = get_parent().get_parent().get_parent()
	# Getting the value of self_damage from player.
	#self_damage = player.self_damage
	self_damage = true
	fire_duration_timer.wait_time = ground_fire_duration
	burn_check_timer.wait_time = burn_check_rate
	fire_duration_timer.start()
	burn_check_timer.start()
	monitoring = true


func _on_burn_check_timer_timeout():
	monitoring = false
	await get_tree().create_timer(0.05)
	monitoring = true


func _on_time_burning_ground_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body is PlayerClass and not self_damage:
		return
	#print("Body entered: ", body)
	for child in body.get_children():
		if child is HealthComponent:
			# Deferring the call otherwise it doesn't work with the collision shape or smth.
			child.set_on_fire(burn_time, burn_damage)
	
