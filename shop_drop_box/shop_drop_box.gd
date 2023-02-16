extends Node2D

var player_in_area = null
var is_mouse_in_area := false

func _on_player_area_mask_area_entered(area):
	if area.is_in_group('player'):
		player_in_area = area
		refesh_hight_list()

func _on_player_area_mask_area_exited(area):
	if area.is_in_group('player'):
		player_in_area = null
		refesh_hight_list()

func _on_player_area_mask_mouse_entered():
	is_mouse_in_area = true
	refesh_hight_list()


func _on_player_area_mask_mouse_exited():
	is_mouse_in_area = false
	refesh_hight_list()

func refesh_hight_list():
	if player_in_area != null and is_mouse_in_area:
		var shader_material = ShaderMaterial.new()
		shader_material.shader = load('res://shaders/outline.shader')
		shader_material.set_shader_param('outline_color',Color(1,0,0,1))
		get_node('%animated_sprite').material = shader_material
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		get_node('%animated_sprite').material = null
		Input.set_default_cursor_shape()

func _on_player_area_mask_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('click') and player_in_area!=null:
		EffectManager.get_node('pick_up_item').play()
		var player_inventory = get_tree().get_nodes_in_group('player_inventory')[0]
		player_inventory.merge_item_dict(get_node("%inventory").get_item_dict())
		hide()
		get_node("player_area_mask/collision_shape_2d").disabled = true
		get_node("static_body_2d/collision_shape_2d").disabled = true
		for item in get_node("%inventory").get_item_dict():
			var floating_item_instance = load('res://floating_item/floating_text.tscn').instance()
			floating_item_instance.text = 'X%s'%get_node("%inventory").get_item_dict()[item]
			floating_item_instance.icon = item.icon
			get_tree().get_root().add_child(floating_item_instance)
			floating_item_instance.global_position = global_position
			yield(get_tree().create_timer(0.1),"timeout")
		queue_free()
			
