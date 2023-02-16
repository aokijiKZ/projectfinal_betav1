extends PopupDialog



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_stop_menu_about_to_show():
	get_tree().paused = true
	
func _on_stop_menu_popup_hide():
	get_tree().paused = false

func _on_exit_confirmation_confirm():
	EffectManager.get_node("ui_confirm").play()
	yield(EffectManager.get_node("ui_confirm"),"finished")
	get_tree().quit()

func _on_restart_button_pressed():
	EffectManager.get_node("bong").play()
	get_node('/root/in_game')._on_restart_area_button_pressed()

func _on_setting_button_pressed():
	EffectManager.get_node("bong").play()
	get_node('/root/in_game').get_node('%setting_menu').popup()

func _on_home_button_pressed():
	EffectManager.get_node("bong").play()
	get_node('/root/in_game')._on_go_to_area_selection_button_pressed()

func _on_close_button_pressed():
	EffectManager.get_node("ui_cancel").play()
	$exit_confirmation.popup()
