extends Node2D

var no_continent:int = 0
var no_area:int = 0
var target_oxygen:int = 10
var target_time_sec:int = 100

var money := 10000 setget set_money
var oxygen := 0 setget set_oxygen
var use_time_sec := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Profile.current_no_continent = no_continent
	Profile.current_no_area = no_area
	refesh_oxygen_bar()
	refesh_money_label()

func _process(delta):
	pass

func _on_sec_timer_timeout():
	use_time_sec = use_time_sec+1
	get_node('%time_label').text = '%4d'%use_time_sec

func _on_stop_button_pressed():
	get_node('%stop_menu').popup()

func set_oxygen(v):
	oxygen = v
	check_endgame()
	refesh_oxygen_bar()

func check_endgame():
	if oxygen >= target_oxygen:
		yield(get_tree(),"idle_frame")
		get_node('%end_game_menu').popup()

func refesh_oxygen_bar():
	get_node('%oxygen_bar').value = 100*oxygen/float(target_oxygen)

func _on_restart_area_button_pressed():
	var restart_area_instance = load('res://restart_area/restart_area.tscn').instance()
	self.name = 'remove'
	get_tree().get_root().add_child(restart_area_instance,true)
	queue_free()

func _on_go_to_area_selection_button_pressed():
	var area_selection_instance = load('res://area_selection/area_selection.tscn').instance()
	get_tree().get_root().add_child(area_selection_instance,true)
	queue_free()

func _on_go_to_next_area_button_pressed():
	var next_area_instance = load('res://next_area/next_area.tscn').instance()
	self.name = 'remove'
	get_tree().get_root().add_child(next_area_instance,true)
	queue_free()

func _on_end_game_menu_about_to_show():
	get_tree().paused = true
	var oxygen_ratio:float
	if use_time_sec <= target_time_sec:
		oxygen_ratio = 1.0
	elif use_time_sec > target_time_sec and use_time_sec < 2.0*target_time_sec:
		oxygen_ratio = (2.0*target_time_sec-use_time_sec)/target_time_sec
	else:
		oxygen_ratio = 0.0
	var recive_oxygen = target_oxygen * oxygen_ratio
	var complate_percent = 100* oxygen_ratio
	print_debug(recive_oxygen)
	var str_no_continent = 'continent_%s'%no_continent
	var str_no_area = 'area_%s'%no_area
	if not Profile.stat_dict.has(str_no_continent):
		 Profile.stat_dict[str_no_continent] = {}
	if not Profile.stat_dict[str_no_continent].has(str_no_area):
		Profile.stat_dict[str_no_continent][str_no_area] = {}
	var area_stat = Profile.stat_dict[str_no_continent][str_no_area]
	print_debug(area_stat)
	if area_stat.get('oxygen',0) < recive_oxygen:
		area_stat['oxygen'] = recive_oxygen
	if area_stat.get('percentage',0) < complate_percent:
		area_stat['percentage'] = complate_percent
	if area_stat.get('time',1000000) > use_time_sec:
		area_stat['time'] = use_time_sec
	
	#update_end_game_menu
	get_node('%success_bar').value = complate_percent
	get_node('%used_time').text = '%4d'%use_time_sec
		
func _on_end_game_menu_popup_hide():
	get_tree().paused = false

func refesh_money_label():
	get_node('%money_label').text = str(money)

#func floating_item_money_changed(dif_money):
#	var floating_item_instance = load('res://floating_item/floating_text.tscn').instance()
#	floating_item_instance.text = str(dif_money)
##	floating_item_instance.icon = item.icon
#	get_tree().get_root().add_child(floating_item_instance)
#	floating_item_instance.global_position = global_position

func set_money(v):
#	floating_item_money_changed(v-money)
	money = v
	refesh_money_label()
	
func failed_game():
	get_node('%failed_game_menu').popup()
	
func _on_failed_game_menu_about_to_show():
	get_tree().paused = true

func _on_failed_game_menu_popup_hide():
	get_tree().paused = false
