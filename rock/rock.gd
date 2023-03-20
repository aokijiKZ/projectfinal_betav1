tool
extends StaticBody2D

enum DISPLAY{
	NORMAL,
	RED
}
var display setget set_display
func set_display(v):
	display = v
	if display == DISPLAY.RED and Engine.editor_hint:
		$sprite/animation_player.play("has_red")
	else:
		$sprite/animation_player.play("normal")
		

func _ready():
	if not Engine.editor_hint:
		return
	randomize()
	if randf() < 0.1:
		set_display(DISPLAY.RED)
	else:
		set_display(DISPLAY.NORMAL)
