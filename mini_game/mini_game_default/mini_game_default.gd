extends PopupDialog

var ground_farm

var pressed_time_target:= 3
var pressed_count :=0

func _on_mini_game_default_about_to_show():
	get_tree().get_nodes_in_group('player')[0].is_can_move = false

func _on_mini_game_default_popup_hide():
	get_tree().get_nodes_in_group('player')[0].is_can_move = true


func _on_hole_button_pressed():
	var player = get_tree().get_nodes_in_group('player')[0]
	if player.energy > 0:
		EffectManager.get_node('hit').play()
		get_node("hoe_animation_player").play("hole")
		player.energy = player.energy-1
		if pressed_count+1 >= pressed_time_target:
			pressed_count = 0
		
			ground_farm.state = 'dug'
			hide()
		else:
			pressed_count = pressed_count+1
			ground_farm.frame = ground_farm.frame+ 1 
		get_node("ground").texture = load('res://mini_game/mini_game_default/img/bg_%d.png'%[pressed_count+1])
			
	else:
		player.talk('เหนื่อย')
		hide()


func _on_hole_button_mouse_entered():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load('res://shaders/outline.shader')
	shader_material.set_shader_param('outline_color',Color(1,0,0,1))
	get_node('hoe').material = shader_material


func _on_hole_button_mouse_exited():
	get_node('hoe').material = null


