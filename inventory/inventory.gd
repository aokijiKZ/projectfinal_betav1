extends Node

export var item_dict := {} 

signal item_dict_changed()

#add item to dict 1 quantity
func add_item(item):
	if item in item_dict:
		item_dict[item] += 1
	else:
		item_dict[item] = 1
	emit_signal("item_dict_changed")

#remove item from dict  1 quantity
func remove_item(item):
	if item in item_dict:
		item_dict[item] -= 1
		if item_dict[item] == 0:
			item_dict.erase(item)
	emit_signal("item_dict_changed")

# merge item dict
func merge_item_dict(dict):
	for item in dict:
		if item in item_dict:
			item_dict[item] += dict[item]
		else:
			item_dict[item] = dict[item]
	emit_signal("item_dict_changed")
#erase item from dict
func erase_item(item):
	if item in item_dict:
		item_dict.erase(item)
	emit_signal("item_dict_changed")

# clear item dict
func clear_item_dict():
	item_dict.clear()
	emit_signal("item_dict_changed")

func has_item(item):
	if item in item_dict:
		return true
	else:
		return false

func get_item_dict():
	return item_dict

func get_item(item_name):
	for item in item_dict:
		if item.item_name == item_name:
			return item

# count items in dict with item
func count_item(item):
	if item in item_dict:
		return item_dict[item]
	else:
		return 0

 
