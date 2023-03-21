extends Popup

var card_data_list :Array

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
	## select card
	var current_card = load(Profile.current_card_path) if Profile.current_card_path != null else null
	if current_card!=null and not current_card.resource_path in Profile.own_card_path_list:
		current_card = null
		Profile.current_card_path = null
	if current_card != null:
		$card_choose.card_index = card_data_list.find(current_card)
		$card_choose/card_display.get_node('card').texture = current_card.pic
		$detail/desc_panel/desc.text = current_card.desc
		$detail/buff_panel/buff.text = current_card.get_buff_info()
	else:
		$card_choose/card_display.get_node('card').texture = null
		$detail/desc_panel/desc.text = ''
		$detail/buff_panel/buff.text = ''
	
	## all card
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
		if not cd.resource_path in Profile.own_card_path_list:
			cd_display.is_have = false
			cd_display.get_node('card').self_modulate = Color(0.5,0.5,0.5,1)
		else:
			cd_display.is_have = true
			cd_display.get_node('card').self_modulate = Color(1,1,1,1)
		index = index + 1
		
func _on_card_item_selected(index):
	EffectManager.get_node("bong").play()
	var cd = card_data_list[index]
	$card_desc/title.text = cd.card_name
	$card_desc/desc.text= cd.desc
	$card_desc.popup()
	

func _on_help_button_pressed():
	EffectManager.get_node("bong").play()
	$help_popup.popup()


func _on_exit_card_desc_pressed():
	EffectManager.get_node("ui_cancel").play()
	$card_desc.hide()


func _on_exit_button_pressed():
	EffectManager.get_node("ui_cancel").play()
	self.hide()

func _on_card_display_pressed():
	if $card_choose.card_index != null:
		_on_card_item_selected($card_choose.card_index)


func _on_card_menu_about_to_show():
	refesh()
	yield(get_tree(),"idle_frame")
	if Profile.is_first_time_recive_card:
		get_tree().paused = true
		var dialog = Dialogic.start('card')
		yield(get_tree().create_timer(1),"timeout")
		dialog.pause_mode = PAUSE_MODE_PROCESS
		add_child(dialog)
		dialog.connect('timeline_end',self,'_on_dialog_end',[dialog])
		dialog.connect("dialogic_signal", self, "dialog_listener")

func _on_dialog_end(timeline_name,dialog):
	Profile.is_first_time_recive_card = false
	get_tree().paused = false
	dialog.queue_free()

func dialog_listener(string):
	match string:
		"somthing":
			pass


func _on_read_more_button_pressed():
	if $card_choose.card_index !=null:
		_on_card_item_selected($card_choose.card_index)
