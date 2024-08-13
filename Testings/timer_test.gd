extends Node2D

@export var timer: Timer


func _ready() -> void:
	print("Hello 1.")
	print(timer.time_left)
	timer.start()
	await get_tree().create_timer(0.5).timeout
	print(timer.time_left)

func _on_timer_timeout() -> void:
	print("Hello 2.")
