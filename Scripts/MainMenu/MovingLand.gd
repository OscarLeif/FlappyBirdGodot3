extends Node

export(float) var scroll_speed = 2.0
var sprite_size = Vector2()
var initial_positions = []

func _ready():
	if get_child_count() > 0:
		var first_sprite = get_child(0) as Sprite3D
		sprite_size = first_sprite.texture.get_size() # Read the size from the first sprite's texture
	
	# Store the initial positions of the sprites
	for i in range(get_child_count()):
		var sprite = get_child(i) as Sprite3D
		initial_positions.append(sprite.transform.origin)
	
	# Position the sprites in a line initially
	for i in range(get_child_count()):
		var sprite = get_child(i) as Sprite3D
		sprite.transform.origin.x = initial_positions[i].x

func _process(delta):
	for i in range(get_child_count()):
		var sprite = get_child(i) as Sprite3D
		sprite.transform.origin.x -= scroll_speed * delta

		# Check if the sprite has moved past the leftmost initial position
		if sprite.transform.origin.x < initial_positions[0].x:
			# Find the rightmost sprite's position
			var rightmost_position = find_rightmost_position()
			# Move this sprite to the right of the rightmost sprite
			sprite.transform.origin.x = rightmost_position.x + sprite_size.x

# Helper function to find the rightmost sprite's position
func find_rightmost_position() -> Vector3:
	var rightmost_position = initial_positions[0]
	for i in range(1, get_child_count()):
		var sprite = get_child(i) as Sprite3D
		if sprite.transform.origin.x > rightmost_position.x:
			rightmost_position = sprite.transform.origin
	return rightmost_position
