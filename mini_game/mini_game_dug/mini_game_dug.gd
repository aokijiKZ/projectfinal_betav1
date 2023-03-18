extends PopupDialog

var ground_farm

var pressed_time_target:= 3
var pressed_count :=0

func _ready():
	get_tree().get_nodes_in_group('player_inventory')[0].connect('item_dict_changed',self,'refesh')
	

func refesh():
	get_node('%seed_item_list').clear()
	var inventory = get_tree().get_nodes_in_group('player_inventory')[0]
	var index = 0
	for item in inventory.item_dict:
		if item is ItemSeed:
			get_node('%seed_item_list').add_item('%s X%s'%[item.item_name,inventory.item_dict[item] ],item.icon)
			get_node('%seed_item_list').set_item_metadata(index,item)
			index = index +1
	
func _on_mini_game_dug_about_to_show():
	get_tree().get_nodes_in_group('player')[0].is_can_move = false
	pressed_count = 0
	refesh()


func _on_mini_game_dug_popup_hide():
	get_tree().get_nodes_in_group('player')[0].is_can_move = true

