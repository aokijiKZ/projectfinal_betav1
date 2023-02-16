extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	for effect in get_children():
		effect.bus = 'Effect'

#func play_effect(effect_name):
#	var effect_player = get_node_or_null(effect_name)
#	if effect_player == null:
#		printerr('no '+effect_name+' this effect name')
#		return 
#	effect_player.play()
#	effect_player.play()
#	return effect_player
