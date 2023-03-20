extends Control


func _ready():
	var dialog = Dialogic.start('complate_game')
	add_child(dialog)
	dialog.connect('timeline_end',self,'_on_dialog_end')
	dialog.connect("dialogic_signal", self, "dialog_listener")

func _on_dialog_end(timeline_name):
	to_title_menu()
	
func _on_skip_button_pressed():
	to_title_menu()
	
func to_title_menu():
	get_tree().change_scene("res://title_menu/title_menu.tscn")

func dialog_listener(string):
	match string:
		"hide_skip_bt":
			$canvas_layer/skip_button.hide()
