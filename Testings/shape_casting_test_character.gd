extends CharacterClass

@export var shape : CollisionShape2D


# Fuck this shit, I'm outta here. This is not working, I don't know why, nsm.

#func _ready():
	#var shape = $AreaOfEffect/AOEZone
	##shape.monitoring = false
	#print(shape)
#
#
#func _process(_delta):
	## This version is an attempt at using shape-casting. This is not working, fml.
	#var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	#var query : PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	#query.set_shape(shape.shape)
	#print("shape: %s, shape.shape: %s" % [shape, shape.shape])
	#print("query: ",query)
	#var result : Array[Dictionary] = space_state.intersect_shape(query, 10)
	#print("result: ", result)
	##pass
