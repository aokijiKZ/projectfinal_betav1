extends Popup

var no_continent
var no_area 

var map_instance

func _on_close_button_pressed():
	EffectManager.get_node("ui_cancel").play()
	hide()

func _on_play_button_pressed():
	EffectManager.get_node("ui_confirm").play()
	var in_game_instance = load('res://in_game.tscn').instance()
	in_game_instance.target_oxygen = map_instance.target_oxygen
	in_game_instance.target_time_sec = map_instance.target_time_sec
	in_game_instance.no_continent = no_continent
	in_game_instance.no_area = no_area
	get_tree().get_root().add_child(in_game_instance,true)
	in_game_instance.get_node('%map').add_child(map_instance,true)
	
	get_node('/root/area_selection').queue_free()
#	get_tree().change_scene("res://in_game.tscn")

func _on_level_detail_about_to_show():
	get_node('%continent_and_area_name').text = 'ทวีปที่ %d - พื้นที่ %d'%[no_continent+1,no_area+1]
	var str_no_continent = 'continent_%s'%no_continent
	var str_no_area = 'area_%s'%no_area
	var continent_stat = Profile.stat_dict.get(str_no_continent,{})
	var area_stat = continent_stat.get(str_no_area,{})
	
	#load map
	map_instance = load('res://map/contient_%s/area_%s/contient_%s_area_%s.tscn'%[no_continent,no_area,no_continent,no_area]).instance()
	get_node('%target_time').text = '%2d'%map_instance.target_time_sec
	get_node('%oxygen_recive').text = '%s'%map_instance.target_oxygen
	
	#select display :after_play or before_play
	$after_play.visible = false
	$before_play.visible = false
	if area_stat.empty():
		$before_play.visible = true
		$before_play/bg_mission/target_oxy.text = 'ทำออกซิเจนให้ถึง %d หน่วย'%map_instance.target_oxygen
		$before_play/bg_mission/target_time.text = 'ภายในระยะเวลา %d วินาที'%map_instance.target_time_sec
	else:
		$after_play.visible = true
		get_node('%used_time').text = '%2d'%area_stat.get('time') if area_stat.get('time') != null else '-'
		get_node('%received_oxygen').text = '%2d'%area_stat.get('oxygen') if area_stat.get('oxygen') != null else '-'
		get_node('%complate_percent').text = '%2d'%area_stat.get('percentage') if area_stat.get('percentage') != null else '-'
	
	
	
	
	
	var img = load('res://map/contient_%s/area_%s/contient_%s_area_%s.png'%[no_continent,no_area,no_continent,no_area])
	get_node('%map_texture_rect').texture = img
	
	#choose 'new card label' visible 
	$help_bt/new_card_label.visible = false
	if Profile.new_own_card_path_list.size() >0:
		$help_bt/new_card_label.visible = true
		

func _on_help_bt_pressed():
	EffectManager.get_node("bong").play()
	$card_menu.popup()
	
	#clear new card cach
	Profile.new_own_card_path_list.clear()
	$help_bt/new_card_label.visible = false
