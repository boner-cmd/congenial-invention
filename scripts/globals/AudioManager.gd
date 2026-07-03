extends Node

#BGM
const BGM_tracks : Dictionary[int, AudioStream] = {
}

#SFX

#AudioStreamPlayers
var SFX_Player : AudioStreamPlayer
var BGM_Player : AudioStreamPlayer
var temp_BGM_Player : AudioStreamPlayer


func _ready() -> void:
	var tree = get_tree().get_root()
	SFX_Player = AudioStreamPlayer.new()
	SFX_Player.process_mode = PROCESS_MODE_ALWAYS
	SFX_Player.bus = "Sound Effects"
	SFX_Player.autoplay = true
	tree.add_child.call_deferred(SFX_Player)
	
	BGM_Player = AudioStreamPlayer.new()
	BGM_Player.bus = "Music"
	BGM_Player.autoplay = true
	BGM_Player.process_mode = PROCESS_MODE_ALWAYS
	tree.add_child.call_deferred(BGM_Player)
	
	temp_BGM_Player = BGM_Player.duplicate()
	#temp_BGM_Player.stream = BGM_tracks[] ##TODO needs to be set to the initial BGM track
	get_tree().root.add_child.call_deferred(temp_BGM_Player)
	#temp_BGM_Player.process_mode = PROCESS_MODE_ALWAYS #need to decide if pausing pauses BGM, lean towards no
	await temp_BGM_Player.tree_entered
	temp_BGM_Player.play()


##Sound Effect One-Shot. Pitch Range defaults to -0.1, 0.1 and can be changed when called.
func sfx_play(sfx : AudioStream, pitch_range: float = randf_range(-0.1, 0.1)):
	var Temp_SFX_Player = SFX_Player.duplicate()
	Temp_SFX_Player.stream = sfx
	get_tree().root.add_child.call_deferred(Temp_SFX_Player)
	await Temp_SFX_Player.tree_entered
	#individual tweeks here per sfx played, if any
	Temp_SFX_Player.play()
	await Temp_SFX_Player.finished
	Temp_SFX_Player.queue_free()


##BGM cycles by Track ID, tween out the old track and plays the new.
func bgm_cycle(trackID: int):
	await TweenManager.tween_object(temp_BGM_Player, "volume_linear", 0.0, .7)
	temp_BGM_Player.queue_free()
	temp_BGM_Player = BGM_Player.duplicate()
	temp_BGM_Player.stream = BGM_tracks[trackID]
	get_tree().root.add_child(temp_BGM_Player)
	
	if temp_BGM_Player: #this was needed for a reason that may be obsolete moving to a new structure
		temp_BGM_Player.play()
