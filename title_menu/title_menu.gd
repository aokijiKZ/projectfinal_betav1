extends Popup

func _ready():	
	get_node("%exit_confirmation").connect("confirm",self,"_on_exit_confirmation_confirm")
	yield(get_tree(),"idle_frame")
	popup()
	MusicManager.play_music()

func _on_start_button_pressed():
	MusicManager.stop_music()
	EffectManager.get_node("ui_confirm").play()
	get_tree().change_scene("res://area_selection/area_selection.tscn")
	
func _on_setting_button_pressed():
	EffectManager.get_node("ui_confirm").play()
	get_node("%setting_menu").popup()

func _on_exit_button_pressed():
	EffectManager.get_node("ui_confirm").play()
	get_node("%exit_confirmation").popup_centered()

func _on_exit_confirmation_confirm():
	get_tree().quit()

