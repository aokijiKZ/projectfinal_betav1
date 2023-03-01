extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state = 'open'

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_nodes_in_group('player_inventory')[0].connect('item_dict_changed',self,'refesh')
	refesh()


func refesh():
	clear()
	var inventory = get_tree().get_nodes_in_group('player_inventory')[0]
	var index = 0
	for item in inventory.get_item_dict():
		add_item('%s X%s'%[item.item_name,inventory.item_dict[item] ],item.icon)
		set_item_metadata(index,item)
		set_item_tooltip(index,item.get_info())
		var can_select = item is ItemRestoreEnergy or item is ItemUnlimitEnergy
		set_item_selectable(index,can_select)
		index = index +1


func _on_player_inventory_list_item_activated(index):
	var inventory = get_tree().get_nodes_in_group('player_inventory')[0]
	if is_item_selectable(index):
		var item = get_item_metadata(index)
		if item is ItemRestoreEnergy:
			get_tree().get_nodes_in_group('player')[0].energy = get_tree().get_nodes_in_group('player')[0].energy + item.restore_energy_point
			inventory.remove_item(item)
		elif item is ItemUnlimitEnergy:
			get_tree().get_nodes_in_group('player')[0].unlimit_energy(item.unlimit_energy_time_sec)
			inventory.remove_item(item)
		else:
			printerr('no implement')

func close_player_inv():
	if state == 'open':
		$"../animation_player".play("hide")
		yield($"../animation_player","animation_finished")
		state = 'close'
	
func open_player_inv():
	if state == 'close':
		$"../animation_player".play("show")
		yield($"../animation_player","animation_finished")
		state = 'open'

func _on_close_player_inv_button_pressed():
	EffectManager.get_node("bong").play()
	close_player_inv()

func _on_open_player_inv_button_pressed():
	EffectManager.get_node("bong").play()
	open_player_inv()
