extends Spatial
export(NodePath) var sprite_path
export(NodePath) var Player_path

export(float) var cameraOffsetX = 0
export(float) var playerSpeed = 1
export(int) var num_sprites_each_side = 4

var sprite_copies = []
onready var sprite3D: Sprite3D = get_node("Land/Land0")
onready var NodeLand:Node = get_node("Land")
onready var camera:Camera = get_node("Camera")

var sprite3d_width:float
var Player: RigidBody

enum GameState {
	WAIT,
	PLAYING,
	DEAD
}

var game_state = GameState.WAIT

# Variable to hold the current state

func _ready():
	var sprite_width = sprite3D.texture.get_size().x * sprite3D.pixel_size #return texture to world size
	sprite3d_width = sprite_width
	var originalSpritePos = sprite3D.global_position
	print("Original pos: " + str(originalSpritePos))
	print("Sprite Width : " + str(sprite_width))
	sprite_copies.append(sprite3D)
	for i in range(num_sprites_each_side):
		#create left
		var left_sprite = sprite3D.duplicate()
		var spawnPos = Vector3(sprite3D.global_position.x-(i+1)* sprite_width, sprite3D.position.y,0 )
		print("Spawn pos "+ str(spawnPos))
		left_sprite.global_position = spawnPos
		NodeLand.add_child(left_sprite)
		sprite_copies.append(left_sprite)
		
#		#create right
#		var right_sprite = sprite3D.duplicate()
#		var spawnPosRight = Vector3(sprite3D.global_position.x+(i+1)* sprite_width, sprite3D.position.y,0 )
#		left_sprite.global_position = spawnPosRight
#		NodeLand.add_child(right_sprite)
#		sprite_copies.append(right_sprite)		
	Player = get_node(Player_path)
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if game_state==GameState.WAIT:
			change_game_state(GameState.PLAYING)
		elif game_state==GameState.PLAYING:
			Player.linear_velocity = Vector3(1,0,0)
			Player.apply_central_impulse(Vector3(0,5,0))
			Player.angular_velocity = Vector3(0,0,4.0)
		
func change_game_state(new_state):
	game_state = new_state
	match game_state:
		GameState.WAIT:
			print("State change to WAIT")
		GameState.PLAYING:
			Player.gravity_scale = 1		
			Player.linear_velocity=Vector3(1,0,0)	
			print("State change to Playing")
		GameState.DEAD:
			print("State Change to DEAD")


func _process(delta):
	# Core game move the player to the right
	
	if game_state== GameState.WAIT:
		Player.translation.x += delta * playerSpeed
	elif game_state == GameState.PLAYING:
		
		if Player.linear_velocity.y>0:
			if Player.rotation.z > deg2rad(30):
				Player.angular_velocity= Vector3(0,0,0)
		if Player.linear_velocity.y <0:
			if Player.rotation.z < deg2rad(-90):
				Player.angular_velocity= Vector3.ZERO;
			else:
				Player.angular_velocity = Vector3(0,0,-2)
		pass
	
	_cameraController()
	_groundController()
	
	var playerVel = Player.linear_velocity
	
	
	
#	if Player.rotation.z < deg2rad(-30):
#		Player.rotation.z = deg2rad(-30)
#	if Player.rotation.z > deg2rad(30):
#		Player.rotation.z = deg2rad(30)		
	
	pass
	
func _cameraController():
	var playerPos = Player.translation
	var cameraPos = camera.translation
		
	var newCameraPos = Vector3(playerPos.x+cameraOffsetX, cameraPos.y, cameraPos.y)
	camera.translation = newCameraPos

#	we just swap the far left to next far right when a sprite is outside the view 
func _groundController():
	# Get camera orthographic size and viewport size
	var orth_size = camera.size
	var viewport_size = get_viewport().size
	var aspect_ratio = viewport_size.x / viewport_size.y
	
	# Calculate the half extents of the orthographic projection
	var half_height = orth_size
	var half_width = orth_size * aspect_ratio
	
	# Get the camera's global position
	var camera_pos = camera.global_transform.origin
	
	# Calculate the corners in world space
	var top_left = camera_pos + Vector3(-half_width, half_height, 0)
	var top_right = camera_pos + Vector3(half_width, half_height, 0)
	var bottom_left = camera_pos + Vector3(-half_width/2, -half_height, 0)
	var bottom_right = camera_pos + Vector3(half_width, -half_height, 0)
	
#	print("Top Left: ", top_left)
#	print("Top Right: ", top_right)
#	print("Bottom Left: ", bottom_left)
#	print("Bottom Right: ", bottom_right)
	
	# Example usage for repositioning sprites
	for sprite3D in sprite_copies:
		var spritePos = sprite3D.translation
		var aabb = sprite3D.get_aabb()
		var sprite_min = aabb.position
		var sprite_max = spritePos+ aabb.position + aabb.size
		
		# If the sprite is out of the left boundary, move it to the right
		if sprite_max.x < bottom_left.x:
			var rightmost_sprite = sprite_copies[0]
			for s in sprite_copies:
				if s.translation.x >= rightmost_sprite.translation.x:
					rightmost_sprite = s	
			
			# Calculate new position for the sprite that moved out of view
			var new_position = rightmost_sprite.translation
			new_position.x += sprite3d_width
			sprite3D.translation = new_position
			break

	# Optional: Log to check positions
#	for sprite3D in sprite_copies:
#		print("Sprite position: " + str(sprite3D.translation))
