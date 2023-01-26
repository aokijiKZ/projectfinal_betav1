extends CanvasLayer


func _ready():
	yield(get_tree().create_timer(0.5),"timeout")
	var find_no_contient = Profile.current_no_continent+1
	var find_no_area = Profile.current_no_area+1
	var map_path = 'res://map/contient_%s/area_%s/contient_%s_area_%s.tscn'%[find_no_contient,find_no_area,find_no_contient,find_no_area]
	if File.new().file_exists(map_path):
		var map_instance = load(map_path).instance()
		var in_game_instance = load('res://in_game.tscn').instance()
		in_game_instance.target_oxygen = map_instance.target_oxygen
		in_game_instance.target_time_sec = map_instance.target_time_sec
		get_tree().get_root().add_child(in_game_instance,true)
		in_game_instance.get_node('%map').add_child(map_instance,true)
		self.queue_free()
	else:
		var area_selection_instance = load('res://area_selection/area_selection.tscn').instance()
		get_tree().get_root().add_child(area_selection_instance,true)
		queue_free()
