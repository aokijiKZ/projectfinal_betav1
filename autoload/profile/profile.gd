extends Node

const PROFILE_PATH = "user://profile"

var stat_dict :={
	
}

var current_no_continent
var current_no_area

#card
var own_card_path_list := []
var new_own_card_path_list :=[]
var current_card_path

#flag
var is_first_time_complate_game = true
var is_first_time_open_game = true
var is_first_time_in_area_selection = true
var is_first_time_recive_card = true
var is_first_time_in_shop = true
var is_first_time_in_game = true

func _ready():
	load_from_file()

func load_from_file():
	var f = File.new()
	if not f.file_exists(PROFILE_PATH):
		return
	f.open(PROFILE_PATH, File.READ)
	var str_data = f.get_as_text()
	f.close()
	var data = parse_json(str_data)
	stat_dict = data.stat_dict
	own_card_path_list = data.own_card_path_list
	current_card_path = data.current_card_path
	is_first_time_complate_game = data.is_first_time_complate_game
	is_first_time_open_game = data.is_first_time_open_game
	is_first_time_in_area_selection = data.is_first_time_in_area_selection
	is_first_time_recive_card = data.is_first_time_recive_card
	is_first_time_in_shop = data.is_first_time_in_shop
	is_first_time_in_game = data.is_first_time_in_game
	
func save_to_file():
	var f = File.new()
	f.open(PROFILE_PATH, File.WRITE)
	var data = {
		'stat_dict':stat_dict,
		'own_card_path_list':own_card_path_list,
		'current_card_path':current_card_path,
		'is_first_time_complate_game':is_first_time_complate_game,
		'is_first_time_open_game':is_first_time_open_game,
		'is_first_time_in_area_selection':is_first_time_in_area_selection,
		'is_first_time_recive_card':is_first_time_recive_card,
		'is_first_time_in_shop':is_first_time_in_shop,
		'is_first_time_in_game':is_first_time_in_game
	}
	f.store_string(to_json(data))
	f.close()

func get_total_oxygen():
	var total_oxygen = 0
	for c_data in stat_dict.values():
		for a_data in c_data.values():
			total_oxygen = total_oxygen+a_data.get('oxygen',0)
	return total_oxygen

func _exit_tree():
	save_to_file()


func _on_profile_tree_exiting():
	save_to_file()
