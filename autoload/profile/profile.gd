extends Node

const PROFILE_PATH = "user://profile"

var stat_dict :={
	
}

var current_no_continent
var current_no_area

func _ready():
	load_from_file()

func load_from_file():
	var f = File.new()
	if not f.file_exists(PROFILE_PATH):
		return
	f.open(PROFILE_PATH, File.READ)
	var str_stat_dict = f.get_as_text()
	print_debug(str_stat_dict)
	f.close()
	stat_dict = parse_json(str_stat_dict)

func save_to_file():
	var f = File.new()
	f.open(PROFILE_PATH, File.WRITE)
	f.store_string(to_json(stat_dict))
	f.close()

func _exit_tree():
	save_to_file()
