extends Button


func get_drag_data(position):
	var data = {
		'card_index':get_index(),
		'card_pic':$card.texture
	}
	var control = Control.new()
	var texturerect = TextureRect.new()
	texturerect.texture = $card.texture
	texturerect.rect_size = Vector2(40, 48)
	texturerect.rect_position = -0.5 * texturerect.rect_size
	control.add_child(texturerect)
	set_drag_preview(control)
	return data
