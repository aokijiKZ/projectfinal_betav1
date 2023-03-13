extends TextureButton


func _on_help_button_pressed():
	$help_popup.visible = !$help_popup.visible
