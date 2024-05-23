extends Node

# Speed at which the sprites will scroll
export var scroll_speed : float = 2.0

# Width of each sprite, to be determined dynamically
var sprite_width : float = 0.0
var firstSpritePos: Vector3

# List to hold references to the Sprite3D nodes
var sprites = []

func _ready():
	# Gather all Sprite3D children
	for child in get_children():
		if child is Sprite3D:
			sprites.append(child)
			
	# Ensure there is at least one Sprite3D child
	if sprites.size() > 0:
		call_deferred("calculate_sprite_size")
				
		
func calculate_sprite_size():
	# Get the width of the first child after ensuring it is fully initialized
	sprite_width = sprites[0].get_aabb().size.x
	print("Sprite width determined as: ", sprite_width)		
	
	var leftmost_sprite = sprites[0]
	for s in sprites:
		if s.translation.x < leftmost_sprite.translation.x:
			leftmost_sprite = s
	firstSpritePos = leftmost_sprite.translation
			
func _process(delta):
	for sprite in sprites:
		# Move each sprite to the left
		sprite.translation.x -= scroll_speed * delta

		# If a sprite has moved out of the screen, reposition it to the right end
		if sprite.translation.x < firstSpritePos.x:
			print("Ok we should move just one sprite")
			# Find the rightmost sprite
			var rightmost_sprite = sprites[0]
			for s in sprites:
				if s.translation.x > rightmost_sprite.translation.x:
					rightmost_sprite = s

			# Reposition the current sprite to the right of the rightmost sprite
			sprite.translation.x = rightmost_sprite.translation.x + sprite_width
