extends Control

func _ready():
	print(Profile.is_first_time_open_game)
	if Profile.is_first_time_open_game:
		var dialog = Dialogic.start('intro')
		add_child(dialog)
		dialog.connect('timeline_end',self,'_on_dialog_end')
		dialog.connect("dialogic_signal", self, "dialog_listener")
	else:
		yield(get_tree().create_timer(0.1),"timeout")
		to_title_menu()

func _on_dialog_end(timeline_name):
	to_title_menu()
	
func _on_skip_button_pressed():
	to_title_menu()
	
func to_title_menu():
	Profile.is_first_time_open_game = false
	var title_menu_instance = load('res://title_menu/title_menu.tscn').instance()
	get_tree().get_root().add_child(title_menu_instance,true)
	queue_free()

func dialog_listener(string):
	match string:
		"hide_skip_bt":
			$canvas_layer/skip_button.hide()
