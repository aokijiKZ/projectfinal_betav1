extends Popup

func _ready():
	
	var list_contient :=[]
	var find_no_contient = 0
	while true:
		var list_area :=[]
		var find_no_area = 0
		var contient_path = 'res://map/contient_%s'%find_no_contient
		if not Directory.new().dir_exists(contient_path):
			break
		while true:
			var file_path = 'res://map/contient_%s/area_%s/contient_%s_area_%s.tscn'%[find_no_contient,find_no_area,find_no_contient,find_no_area]
			if not File.new().file_exists(file_path):
				break
			get_node('%capture_scene_img').capture(file_path)
			list_area.append(file_path)
			find_no_area = find_no_area+1
		
		list_contient.append(list_area)
		find_no_contient = find_no_contient+1
	
	for no_contient in list_contient.size():
		var item_list_instance
		if no_contient ==0:
			item_list_instance = $map_tab_container/continent_template
		else:
			item_list_instance = $map_tab_container.get_child(0).duplicate()
			$"%map_tab_container".add_child(item_list_instance)
		item_list_instance.clear()
		item_list_instance.name = 'ทวีป %s'%[no_contient+1]
		for no_area in list_contient[no_contient].size():
			var img = load('res://map/contient_%s/area_%s/contient_%s_area_%s.png'%[no_contient,no_area,no_contient,no_area])
			item_list_instance.add_item('พื้นที่ %s'%[no_area+1],img)
	
	
	yield(get_tree(),"idle_frame")
	popup()
	
	if Profile.current_no_continent !=null and Profile.current_no_area!=null:
		get_node('%area_detail').no_continent = Profile.current_no_continent
		get_node('%area_detail').no_area = Profile.current_no_area
		get_node('%area_detail').popup_centered()
	
	#choose 'new card label' visible 
	$card_menu_bt/new_card_label.visible = false
	if Profile.new_own_card_path_list.size() >0:
		$card_menu_bt/new_card_label.visible = true
		
	#update total oxygen
	var total_oxygen = Profile.get_total_oxygen()
	var total_target_oxygen = 0
	for l_f_a in list_contient:
		for f in l_f_a:
			var map = load(f).instance()
			total_target_oxygen = total_target_oxygen+map.target_oxygen
			map.queue_free()
	$oxygen_progress_bar/total_oxygen.text	= 'ออกซิเจน %d/%d'%[total_oxygen,total_target_oxygen]
	$oxygen_progress_bar.max_value = total_target_oxygen
	$oxygen_progress_bar.value = total_oxygen


func _on_level_item_activated(index):
	var no_continent = get_node('%map_tab_container').current_tab
	var item_list = get_node('%map_tab_container').get_child(no_continent)
	var no_area = item_list.get_selected_items()[0]
	get_node('%area_detail').no_continent = no_continent
	get_node('%area_detail').no_area = no_area
	get_node('%area_detail').popup_centered()
	EffectManager.get_node("ui_confirm").play()


func _on_map_tab_container_tab_changed(tab):
	EffectManager.get_node("ui_focus_button").play()
	
func _on_area_selected(index):
	EffectManager.get_node("ui_focus_button").play()


func _on_back_button_pressed():
	get_tree().change_scene("res://title_menu/title_menu.tscn")

func _on_card_menu_bt_pressed():
	EffectManager.get_node("bong").play()
	$card_menu.popup()
	
	#clear new card cach
	Profile.new_own_card_path_list.clear()
	$card_menu_bt/new_card_label.visible = false
