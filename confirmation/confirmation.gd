tool
extends PopupDialog

export var text_label:String setget set_text_label

signal confirm()

func set_text_label(text):
	text_label = text
	get_node('%label').text = text_label

func _on_confirm_button_pressed():
	emit_signal("confirm")

func _on_cancle_button_pressed():
	hide()
