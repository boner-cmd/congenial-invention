extends Node

var current_tweens : Dictionary = {}
var set_loops_bool : bool = false

func _ready() -> void:
	pass # Replace with function body.

##Tweens specified object by property, property goal, and time. TransitionType default LINEAR, EaseType default EASE_IN. Looping is default false.
##If true and loop_amount == 0, will loop until node freed. Starts Loaded will load the tween at the specifid time, but defaults to 0.0.
func tween_object(object : Object, property : NodePath, goal : Variant, time : float, 
			transtype : Tween.TransitionType = Tween.TRANS_LINEAR, easetype : Tween.EaseType = Tween.EASE_IN,
			loops : bool = false, loop_amount : int = 0,
			starts_loaded : bool = false, custom_time : float = 0.0) -> void:
	
	if object.is_in_group("Current_Tweened_Objects"):
		current_tweens[object].kill()
		current_tweens.erase(object)
		object.remove_from_group("Current_Tweened_Objects")
	
	object.add_to_group("Current_Tweened_Objects")
	var tweened_object
	
	if loops == false:
		tweened_object = get_tree().create_tween()
	elif loop_amount == 0:
		tweened_object = get_tree().create_tween().set_loops()
	else:
		tweened_object = get_tree().create_tween().set_loops(loop_amount)
	
	tweened_object.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	current_tweens[object] = tweened_object
	var tweener_object = tweened_object.tween_property(object, property, goal, time).from_current()
	
	if starts_loaded == true:
		tweened_object.custom_step(custom_time)
		
	tweener_object.set_trans(transtype).set_ease(easetype)
	tweened_object.play()
	await tweened_object.finished
	current_tweens.erase(object)
	object.remove_from_group("Current_Tweened_Objects")
	if tweened_object and tweened_object.is_valid():
		tweened_object.kill()
