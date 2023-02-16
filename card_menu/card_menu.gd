extends Popup

var card_data_list :Array

onready var card_item_list = $"%card_item_list"

func _ready():
	card_data_list = load_card_from_file()
	refesh()

func load_card_from_file():
	var dir = Directory.new()
	var dir_path = 'res://card/instance/'
	dir.open(dir_path)
	dir.list_dir_begin(true,true)
	var card_data_list := []
	while true:
		var filename = dir.get_next()
		if filename == "":
			break
		if not filename.ends_with(".tres"):
			continue
		var card_data = load("%s/%s" % [dir_path,filename])
		card_data_list.append(card_data)
	dir.list_dir_end()
	return card_data_list
	
func refesh():
	card_item_list.clear()
	var index = 0
	for card_data in card_data_list:
		if card_data.resource_path in Profile.own_card_path_list:
			card_item_list.add_icon_item(card_data.pic)
			if Profile.current_card_path == card_data.resource_path:
				card_item_list.select(index,true)
		else:
			card_item_list.add_icon_item(card_data.pic,false)
		card_item_list.set_item_metadata(index,card_data)
		index = index + 1
	
func _on_card_item_list_item_selected(index):
	var card_data = card_item_list.get_item_metadata(index)
	Profile.current_card_path = card_data.resource_path
