extends Spatial

export(NodePath) var sprite_path
export(NodePath) var Player_path

export(float) var cameraOffsetX = 0
export(float) var playerSpeed = 2
export(int) var num_sprites_each_side = 4

var sprite_copies = []
onready var sprite3D: Sprite3D = get_node("Land/Land0")
onready var NodeLand:Node = get_node("Land")
onready var camera:Camera = get_node("Camera")

var Player: RigidBody


func _ready():
	var sprite_width = sprite3D.texture.get_size().x * sprite3D.pixel_size #return texture to world size
	var originalSpritePos = sprite3D.global_position
	print("Original pos: " + str(originalSpritePos))
	print("Sprite Width : " + str(sprite_width))
	for i in range(num_sprites_each_side):
		#create left
		var left_sprite = sprite3D.duplicate()
		var spawnPos = Vector3(sprite3D.global_position.x-(i+1)* sprite_width, sprite3D.position.y,0 )
		print("Spawn pos "+ str(spawnPos))
		left_sprite.global_position = spawnPos
		NodeLand.add_child(left_sprite)
		sprite_copies.append(left_sprite)
		
#		#create right
		var right_sprite = sprite3D.duplicate()
		var spawnPosRight = Vector3(sprite3D.global_position.x+(i+1)* sprite_width, sprite3D.position.y,0 )
		left_sprite.global_position = spawnPosRight
		NodeLand.add_child(right_sprite)
		sprite_copies.append(right_sprite)		
	Player = get_node(Player_path)

func _process(delta):
	# Core game move the player to the right
	Player.translation.x += delta * playerSpeed
	
	_cameraController()
	pass
	
func _cameraController():
	var playerPos = Player.translation
	var cameraPos = camera.translation
		
	var newCameraPos = Vector3(playerPos.x+cameraOffsetX, cameraPos.y, cameraPos.y)
	camera.translation = newCameraPos

#	we just swap the far left to next far right when a sprite is outside the view 
func _groundController():
	var cameraDepth = abs(camera.translation.z)
	var viewport_size = Vector2(get_viewport().size.x,  get_viewport().size.y)
	var top_left = camera.project_position(Vector2(0, 0) , cameraDepth)
	var top_right = camera.project_position(Vector2(viewport_size.x, 0), cameraDepth)
	var bottom_left = camera.project_position(Vector2(0, viewport_size.y), cameraDepth)
	var bottom_right = camera.project_position(Vector2(viewport_size.x, viewport_size.y),cameraDepth)
	
	for sprite3D in sprite_copies:
		var aabb = sprite3D.get_aabb()
		var sprite_min = aabb.position
		
		
		pass
		
