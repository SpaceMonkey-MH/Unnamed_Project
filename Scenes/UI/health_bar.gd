class_name HealthBar
extends TextureProgressBar


#func _ready():
	#set_value(max_value)


#func _process(delta):
	#print("get_progress_texture(): ", get_progress_texture())
	#update_value(-1)
	#print("value in health_bar.gd: ", value)


func set_max_value(new_max_value: float):
	new_max_value = floor(new_max_value)
	# Apparently, this is useless, but I don't get why.
	max_value = new_max_value
	update_value(max_value)


func update_value(new_value: float):
	new_value = floor(new_value)
	value = new_value
