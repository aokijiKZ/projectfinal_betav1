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
	
func save_to_file():
	var f = File.new()
	f.open(PROFILE_PATH, File.WRITE)
	var data = {
		'stat_dict':stat_dict,
		'own_card_path_list':own_card_path_list,
		'current_card_path':current_card_path
	}
	f.store_string(to_json(data))
	f.close()
		
func _exit_tree():
	save_to_file()
