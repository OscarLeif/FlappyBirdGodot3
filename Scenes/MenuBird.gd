extends AnimatedSprite3D


# Export variables to customize the movement
export var move_distance = 1.0   # Distance to move up and down
export var move_time = 1.0       # Time to move up or down

# Original position
var original_position = Vector3()
var up_position = Vector3()

func _ready():
	original_position = self.global_position
	up_position = original_position
	up_position.y+= move_distance
	var tween := create_tween()
	tween.set_loops(-1)
	tween.tween_property(self, "global_position", up_position, move_time)
	tween.tween_property(self, "global_position", original_position, move_time)
