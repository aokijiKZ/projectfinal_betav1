extends Popup

var card_data_list :Array

func _ready():
	card_data_list = load_card_from_file()
	refesh()
	self.popup()

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
	#clear
	for c in $panel_all_card/all_card/h_box_container.get_children():
		c.queue_free()
	#add and connect signal
	var index = 0
	for cd in card_data_list:
		var cd_display = load("res://card_display/card_display.tscn").instance()
		cd_display.get_node('card').texture = cd.pic
		$panel_all_card/all_card/h_box_container.add_child(cd_display)
		cd_display.connect('pressed',self,'_on_card_item_selected',[index])
		index = index + 1
		
func _on_card_item_selected(index):
	var cd = card_data_list[index]
	$card_desc/title.text = cd.card_name
	$card_desc/desc.text= cd.desc
	$card_desc.popup()
	
	
func _on_card_eq(index):
	var cd = card_data_list[index]
	Profile.current_card_path = cd.resource_path

func _on_help_button_pressed():
	$help_popup.popup()
#	$help_popup.visible = !$help_popup.visible


func _on_exit_card_desc_pressed():
	$card_desc.hide()


func _on_exit_button_pressed():
	self.hide()

func _on_card_display_pressed():
	if $card_choose.card_index != null:
		_on_card_item_selected($card_choose.card_index)


func _on_in_side_help_popup_pressed():
	$help_popup.hide()


func _on_exit_help_popup_pressed():
	$help_popup.hide()
