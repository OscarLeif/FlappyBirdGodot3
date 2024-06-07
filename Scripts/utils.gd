extends Node

var score:int=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_main_node():
	var root_node = get_tree().get_root()	
	return root_node.get_child(root_node.get_child_count()-1)
