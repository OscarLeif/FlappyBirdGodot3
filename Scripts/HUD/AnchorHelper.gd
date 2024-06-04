extends Control
tool

export var anchor_portrait = [0.0, 0.0, 0.0, 0.0]
export var anchor_landscape = [0.0, 0.0, 0.0, 0.0]
export var editorUpdate :bool

onready var control_node: Control = $"."

func _ready():
	if len(anchor_portrait)!=4:
		printerr("Anchor must be 4 values")
	if len(anchor_landscape)!=4:
		printerr("Anchor must be 4 values")	

func _process(delta):
	
	if control_node==null:
		print("control node is null")
		control_node=$"."
	
	if editorUpdate==false:
		return
		
#	var screen_size = OS.get_screen_size()	
	var viewport_size = get_viewport_rect().size
#	var isPortrait = screen_size.x < screen_size.y
	var isPortrait = viewport_size.x < viewport_size.y
	
#	print("Screen X: " + str(screen_size.x) + " Y: "+ str(screen_size.y))
	print("Viewport X: " + str(viewport_size.x) + " Y: "+ str(viewport_size.y))
	if isPortrait:
		setupAnchor(anchor_portrait)
	else:
		setupAnchor(anchor_landscape)
		
func setupAnchor(anchor_values: Array):
	if control_node!=null:
		control_node.anchor_left = anchor_values[0]
		control_node.anchor_top = anchor_values[1]
		control_node.anchor_right = anchor_values[2]
		control_node.anchor_bottom = anchor_values[3]	
		
		control_node.margin_left = 0
		control_node.margin_top = 0
		control_node.margin_right=0
		control_node.margin_bottom=0
		print("Ok here setup the anchor and sizes")	
	else:
		print("control_node is null")
		control_node = $"."
	pass;	
