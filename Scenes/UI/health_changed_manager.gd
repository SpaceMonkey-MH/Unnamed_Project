# I think this is used to and only to display the label that indicates damage or heal taken.
extends Control

# The health changed label as a variable, so it can be instanciated.
@export var health_changed_label : PackedScene
# The color of the label when the amount changed is negative (damage).
@export var damage_color : Color = Color.DARK_RED
# The color of the label when the amount changed is positive (heal).
@export var heal_color : Color = Color.DARK_GREEN

# The amount of health changed since the last frame for each node concerned.
var health_changed_d : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Signal health_changed from health_component.
	SignalBus.connect("health_changed", on_signal_health_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	# For each entry in the dictionary.
	for node_id in health_changed_d.keys():
		# Convert the key to a proper id.
		node_id = int(node_id)
		# Call update_label() on the node and value of the dictionary entry. 
		update_label(instance_from_id(node_id), health_changed_d[node_id])
	# We reset the dictionary to empty.
	health_changed_d.clear()


# Procedure that handles the update of the health changed label.
# The goal here is to aggregate the damage labels into one, following the changes on the explosion,
# with the concentric overlapping areas, that made several damages at the same time.
# This works, but the issue might be that it doesn't display heals and damages on the same frame, might have to
# separate the two (like, have two dictionaries?).
func update_label(node : Node, amount_changed : float) -> void:
	# Make it so that there isn't a floating 0 upon rocket explosion.
	if amount_changed == 0:
		return
	# Instanciate the label.
	var label_instance : Label = health_changed_label.instantiate()
	# Give it the amount changed as displaying text.
	label_instance.text = str(amount_changed)
	# Color the label green if it is a heal.
	if amount_changed > 0:
		label_instance.modulate = heal_color
	# Or red if it is a damage.
	else:
		label_instance.modulate = damage_color
	
	node.add_child(label_instance)


# Connected to signal in signal_bus.gd, and in health_component.gd.
# Used to handle what happens when someone's health is changed.
func on_signal_health_changed(node : Node, amount_changed : float) -> void:
	# Get the id of the node.
	var node_id : int = node.get_instance_id()
	# Add the value of the changed health to the value stored in the dictionary.
	if node_id in health_changed_d:
		health_changed_d[node_id] += amount_changed
	# Or create a new entry if the key doesn't exist (else, it crashes).
	else:
		health_changed_d[node_id] = amount_changed

