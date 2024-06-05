extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_ButtonPlay_button_up():
	TransitionKit.fade_to_scene("res://Scenes/Game.tscn", 1.0)	
	pass # Replace with function body.

func _on_ButtonLeaderboard_button_up():
	get_tree().quit()
	pass # Replace with function body.
