extends Popup

func _ready():	
	get_node("%exit_confirmation").connect("confirm",self,"_on_exit_confirmation_confirm")
	yield(get_tree(),"idle_frame")
	popup()
	MusicManager.get_node('title_music').play()


func _on_start_button_pressed():
	MusicManager.get_node('title_music').stop()
	EffectManager.get_node("ui_confirm").play()
	var area_selection_instance = load("res://area_selection/area_selection.tscn").instance()
	get_tree().get_root().add_child(area_selection_instance,true)
	queue_free()
	
func _on_setting_button_pressed():
	EffectManager.get_node("ui_confirm").play()
	get_node("%setting_menu").popup()

func _on_exit_button_pressed():
	EffectManager.get_node("ui_confirm").play()
	get_node("%exit_confirmation").popup_centered()

func _on_exit_confirmation_confirm():
	get_tree().quit()

