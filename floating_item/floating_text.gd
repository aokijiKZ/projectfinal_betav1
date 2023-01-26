extends Node2D

var text:String
var icon:Texture

func _ready():
	get_node("grid_container/label").text = text
	get_node("grid_container/texture_rect").texture = icon
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1)
	tween.parallel().tween_property(self, "position:y", -16.0, 1)
	tween.tween_callback(self, "queue_free")

