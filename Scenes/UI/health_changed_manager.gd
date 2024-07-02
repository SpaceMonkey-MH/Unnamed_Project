# I think this is used to and only to display the label that indicates damage or heal taken.
extends Control

@export var health_changed_label : PackedScene
@export var damage_color : Color = Color.DARK_RED
@export var heal_color : Color = Color.DARK_GREEN


# Called when the node enters the scene tree for the first time.
func _ready():
	# Signal health_changed from health_component.
	SignalBus.connect("health_changed", on_signal_health_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func on_signal_health_changed(node : Node, amount_changed : float):
	if amount_changed == 0:	# Made it so that there isn't a floating 0 upon rocket explosion.
		return
	var label_instance : Label = health_changed_label.instantiate()
	label_instance.text = str(amount_changed)
	
	if amount_changed > 0:
		label_instance.modulate = heal_color
	else:
		label_instance.modulate = damage_color
	
	node.add_child(label_instance)
