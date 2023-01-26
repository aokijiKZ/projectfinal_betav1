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
	
	print_debug(list_contient)
	for c in get_node('map_tab_container').get_children():
		c.queue_free()
	
	for index in list_contient.size():
		var item_list_instance = ItemList.new()
		get_node('map_tab_container').add_child(item_list_instance,true)
		item_list_instance.name = 'ทวีป %s'%[index+1]
		for sub_index in list_contient[index].size():
			item_list_instance.add_item('พื้นที่ %s'%[sub_index+1])
	
	
	
	yield(get_tree(),"idle_frame")
	popup()
	

	
	for c in get_node('map_tab_container').get_children():
		print_debug(c)
		c.connect('item_activated',self,'_on_level_item_activated')
	
	if Profile.current_no_continent !=null and Profile.current_no_area!=null:
		get_node('%area_detail').no_continent = Profile.current_no_continent
		get_node('%area_detail').no_area = Profile.current_no_area
		get_node('%area_detail').popup_centered()
		


func _on_level_item_activated(index):
	var no_continent = get_node('%map_tab_container').current_tab
	var item_list = get_node('%map_tab_container').get_child(no_continent)
	var no_area = item_list.get_selected_items()[0]
	get_node('%area_detail').no_continent = no_continent
	get_node('%area_detail').no_area = no_area
	get_node('%area_detail').popup_centered()
