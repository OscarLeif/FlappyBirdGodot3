extends Spatial

# Speed at which the sprites will scroll
export var scroll_speed : float = 2.0000
export var limitX: float = -6.60

# Width of each sprite, to be determined dynamically
export var sprite_width : float = 0.0000
export var pause:bool
var firstSpritePos: Vector3

# List to hold references to the Sprite3D nodes
var sprites = []

func _ready():
	# Gather all Sprite3D children
	for child in get_children():
		if child is Sprite3D:
			sprites.append(child)
			
	print("Scroll Counter: " + str(len(sprites)))
			
	# Ensure there is at least one Sprite3D child
	if sprites.size() > 0:
		call_deferred("calculate_sprite_size_and_setup_sprites")
				
		
func calculate_sprite_size_and_setup_sprites():
	# Get the width of the first child after ensuring it is fully initialized
	sprite_width = sprites[0].get_aabb().size.x
	print("Sprite width determined as: ", sprite_width)

	# Find the leftmost sprite
	var leftmost_sprite = sprites[0]
	for s in sprites:
		if s.translation.x < leftmost_sprite.translation.x:
			leftmost_sprite = s
	firstSpritePos = leftmost_sprite.translation
	# Position each sprite to the right of the previous one
	var current_x = leftmost_sprite.translation.x
	for i in range(sprites.size()):
		var sprite = sprites[i]
		sprite.translation.x = current_x
		current_x += sprite_width
			
func _process(delta):	
	if pause:
		return
			
	for sprite in sprites:
		# Move each sprite to the left
		sprite.translation.x -= scroll_speed * delta		

		# If a sprite has moved out of the screen, reposition it to the right end
		if sprite.translation.x <= limitX:
			# Find the rightmost sprite
			var rightmost_sprite = sprites[0]
			for s in sprites:
				if s.translation.x >= rightmost_sprite.translation.x:
					rightmost_sprite = s
			
			var movePos = rightmost_sprite.translation
			movePos.x += (sprite_width-scroll_speed*delta)
			sprite.translation = movePos		
