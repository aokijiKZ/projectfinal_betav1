extends PopupDialog

var ground_farm
var is_watering := false

func _ready():
	get_node('%water_bar').value = 0.0

func _process(delta):
	if is_watering:
		get_node('%water_bar').value = float(get_node('%water_bar').value) +0.5

func _on_mini_game_dug_about_to_show():
	get_tree().get_nodes_in_group('player')[0].is_can_move = false


func _on_mini_game_dug_popup_hide():
	get_tree().get_nodes_in_group('player')[0].is_can_move = true
	$help_popup.hide()


func _on_watering_button_button_down():
	get_node("watering_can").texture = load('res://mini_game/mini_game_seed/img/WateringPot2.png')
	$bg2.texture = load("res://mini_game/mini_game_seed/img/bg.png")
	var player = get_tree().get_nodes_in_group('player')[0]
	if player.energy > 0:
		EffectManager.get_node('poured_water').play()
		player.energy = player.energy-1
		is_watering = true
	else:
		player.talk('เหนื่อย')
		hide()
	
func _on_watering_button_button_up():
	EffectManager.get_node('poured_water').stop()
	get_node("watering_can").texture = load('res://mini_game/mini_game_seed/img/WateringPot.png')
	$bg2.texture = load("res://mini_game/mini_game_seed/img/bg_seed.png")
	is_watering = false
	get_node('%watering_button').disabled = true
	if get_node('%water_bar').value <=80 and get_node('%water_bar').value >= 60:
		ground_farm.state = 'watered'
	hide()
	get_node('%watering_button').disabled = false
	get_node('%water_bar').value = 0.0

func _on_watering_button_mouse_entered():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load('res://shaders/outline.shader')
	shader_material.set_shader_param('outline_color',Color(1,0,0,1))
	get_node('watering_can').material = shader_material


func _on_watering_button_mouse_exited():
	get_node('watering_can').material = null


func _on_help_button_pressed():
	$help_popup.visible = !$help_popup.visible
