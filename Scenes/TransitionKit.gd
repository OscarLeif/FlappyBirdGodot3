extends CanvasLayer

# Declare the variables for the transition
onready var color_rect = $ColorRect
onready var tweenFadeIn = get_node("TweenFadeIn")
onready var tweenFadeOut = get_node("TweenFadeOut")

# Store the scene to be loaded
var next_scene = null
var actionTime =0.5

# Signals
func _ready():
	color_rect.modulate.a=0

# Function to handle the transition sequence
func fade_to_scene(scene_path: String, fade_duration: float = 1.0):
	next_scene = scene_path	
	actionTime = fade_duration/2
	tweenFadeIn.interpolate_property(color_rect,"modulate:a",color_rect.modulate.a,1,actionTime,Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
#	tweenFadeIn.connect("tween_completed", self, "_on_fade_completed")
	tweenFadeIn.start()

func _on_TweenFadeIn_tween_completed(object, key):
	print("Fade in is Done")
	get_tree().change_scene(next_scene)
	yield(get_tree().create_timer(0.5), "timeout")
	tweenFadeOut.interpolate_property(color_rect,"modulate:a",color_rect.modulate.a,0,actionTime,Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
#	tweenFadeIn.connect("tween_completed", self, "_on_fade_completed")
	tweenFadeOut.start()	
	pass # Replace with function body.


func _on_TweenFadeOut_tween_completed(object, key):
	print("Here we should disable renderer stuff")
	pass # Replace with function body.
