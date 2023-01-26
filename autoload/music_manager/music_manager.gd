extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	for effect in get_children():
		effect.bus = 'Music'

func play_music():
	get_node("audio_stream_player").play()


func stop_music():
	get_node("audio_stream_player").stop()
