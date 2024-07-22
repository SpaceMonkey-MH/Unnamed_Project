# I think this is used to and only to display the label that indicates damage or heal taken.
extends Control

# The health changed label as a variable, so it can be instanciated.
@export var health_changed_label : PackedScene
# The color of the label when the amount changed is negative (damage).
@export var damage_color : Color = Color.DARK_RED
# The color of the label when the amount changed is positive (heal).
@export var heal_color : Color = Color.DARK_GREEN

# The amount of heal since the last frame for each node concerned.
var heal_d : Dictionary = {}
# The amount of damage since the last frame for each node concerned.
var damage_d : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Signal health_changed from health_component.
	SignalBus.connect("health_changed", on_signal_health_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	# For each entry in the dictionary.
	for node_id in heal_d.keys():
		# Convert the key to a proper id.
		#node_id = int(node_id)
		# Call update_label() on the node and value of the dictionary entry. 
		update_label(instance_from_id(node_id), heal_d[node_id])
	# Same but for damage.
	# For each entry in the dictionary.
	for node_id in damage_d.keys():
		# Convert the key to a proper id.
		#node_id = int(node_id)
		# Call update_label() on the node and value of the dictionary entry. 
		update_label(instance_from_id(node_id), damage_d[node_id])
	# We reset the dictionaries to empty.
	heal_d.clear()
	damage_d.clear()


# Procedure that handles the update of the health changed label.
# The goal here is to aggregate the damage labels into one, following the changes on the explosion,
# with the concentric overlapping areas, that made several damages at the same time.
# This works, but the issue might be that it doesn't display heals and damages on the same frame, might have to
# separate the two (like, have two dictionaries?). Maybe it is not needed, but I'll do it nonetheless.
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
	# Randomizing the spawn position to limit overlap. Values to be balanced.
	#label_instance.position.x = randi_range(-12, 12)
	#print("Node in update_label in health_changed_manager.gd: ", node)
	# Still randomizing the spawn position to avoid overlap, but using the size of the node instead of magics.
	for child : Node in node.get_children():
		if child is HitBoxClass:
			# To prevent a crash if it is a circle or other, to be completed later if needed.
			if child.shape is RectangleShape2D:
				label_instance.position.x = randi_range(-child.shape.size.x / 4, child.shape.size.x / 4)
	node.add_child(label_instance)


# Connected to signal in signal_bus.gd, and in health_component.gd.
# Used to handle what happens when someone's health is changed.
func on_signal_health_changed(node : Node, amount_changed : float) -> void:
	# Get the id of the node.
	var node_id : int = node.get_instance_id()
	if amount_changed > 0:
		# Add the value of the changed health to the value stored in the dictionary.
		if node_id in heal_d:
			heal_d[node_id] += amount_changed
		# Or create a new entry if the key doesn't exist (else, it crashes).
		else:
			heal_d[node_id] = amount_changed
	# Same for damage.
	else:
		# Add the value of the changed health to the value stored in the dictionary.
		if node_id in damage_d:
			damage_d[node_id] += amount_changed
		# Or create a new entry if the key doesn't exist (else, it crashes).
		else:
			damage_d[node_id] = amount_changed

