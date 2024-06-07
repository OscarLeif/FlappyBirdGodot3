extends RigidBody

#var Game = preload("res://Scenes/Game.gd")

onready var GameManager:Game = Utils.get_main_node().get_node("Game")

#Collision stuff should be handled here.
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Player ready")

func _on_PlayerRB_body_entered(body):
	print("Collision done")
	pass # Replace with function body.

func _on_Point_Area_body_entered(body):
	print("Ok The Point should work here")
	pass # Replace with function body.
