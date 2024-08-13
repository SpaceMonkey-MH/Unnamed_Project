class_name TextureProgressBarClass
extends TextureProgressBar

@export var ttr_under: Texture2D
@export var ttr_over: Texture2D
@export var ttr_progress: Texture2D
#@export var f_mode: int = 0


func _ready():
	#set_value(max_value)
	texture_under = ttr_under
	texture_over = ttr_over
	texture_progress = ttr_progress
	#fill_mode = f_mode


#func _process(delta):
	#print("get_progress_texture(): ", get_progress_texture())
	#update_value(-1)
	#print("value in health_bar.gd: ", value)


func set_max_value(new_max_value: float):
	new_max_value = floor(new_max_value)
	# Apparently, this is useless, but I don't get why.
	max_value = new_max_value
	update_value(max_value)


func update_value(value_change: float):
	#print("value_change in health_bar.gd: ", value_change)
	value_change = floor(value_change)
	value += value_change
