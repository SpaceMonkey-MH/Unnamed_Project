extends Node

# Used to connect health_component.gd to health_changed_manager.gd.
signal health_changed(node : Node, amount_changed : float)
