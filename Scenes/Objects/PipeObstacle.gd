extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var camera = utils.get_main_node().get_node("camera")
onready var camera = Utils.get_main_node().get_node("camera")
onready var right = get_node("right")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if camera !=null:
		var orth_size = camera.size
		var viewport_size = get_viewport().size
		var aspect_ratio = viewport_size.x / viewport_size.y
		
		# Calculate the half extents of the orthographic projection
		var half_height = orth_size
		var half_width = orth_size * aspect_ratio
		
		# Get the camera's global position
		var camera_pos = camera.global_transform.origin
		
		# Calculate the corners in world space
		var top_left = camera_pos + Vector3(-half_width/2, half_height/2, 0)
		top_left.z=0	
		var top_right = camera_pos + Vector3(half_width/2, half_height/2, 0)
		top_right.z =0
		var bottom_left = camera_pos + Vector3(-half_width/2, -half_height/2, 0)
		bottom_left.z=0
		var bottom_right = camera_pos + Vector3(half_width/2, -half_height/2, 0)
		bottom_right.z=0
		
		if right.global_position.x < top_left.x:
			print("cleanup pipe")
			queue_free()
	else:
		print("camera not found")
