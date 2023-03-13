extends PopupDialog

var ground_farm


func _on_yield_button_pressed():
	EffectManager.get_node('pick_up_item').play()
	var player = get_tree().get_nodes_in_group('player')[0]
	var inventory = get_tree().get_nodes_in_group('player_inventory')[0]
	inventory.add_item(ground_farm.item_seed.product)
	ground_farm.state = 'cool_down'
	hide()
		
func _on_mini_game_yield_about_to_show():
	get_tree().get_nodes_in_group('player')[0].is_can_move = false


func _on_mini_game_yield_popup_hide():
	get_tree().get_nodes_in_group('player')[0].is_can_move = true


func _on_help_button_pressed():
	$help_popup.visible = !$help_popup.visible
