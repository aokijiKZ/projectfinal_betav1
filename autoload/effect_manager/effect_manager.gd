extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	for effect in get_children():
		effect.bus = 'Effect'
