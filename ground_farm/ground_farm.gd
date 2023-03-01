extends AnimatedSprite


var player_in_area = null
var is_mouse_in_area := false
var item_seed

var state := 'default' setget set_state

func set_state(v):
	state = v
	update_state()

func update_state():
	if state == 'default':
		animation = 'default'
		z_index = -1
	elif state == 'dug':
		animation = 'dug'
		z_index = -1
	elif state == 'seed':
		z_index = -1
		frames.remove_animation('seed')
		frames.add_animation('seed')
		for index in item_seed.grow_textrue_list.size():
			frames.add_frame('seed',item_seed.grow_textrue_list[index],index)
		animation = 'seed'
	elif state == 'watered':
		z_index = -1
		animation = 'seed'
		get_node('%count_down_timer').start(item_seed.growth_time_sec)
		var each_frame_time = item_seed.growth_time_sec / float(item_seed.grow_textrue_list.size()) if not item_seed.grow_textrue_list.empty() else 0
		for i in item_seed.grow_textrue_list.size():
			get_node('%each_frame_timer').start(each_frame_time)
			yield(get_node('%each_frame_timer'),"timeout")
			frame = frame +1 
			z_index = 0
		self.state = 'yield'
	elif state == 'yield':
		get_node('/root/in_game').oxygen = get_node('/root/in_game').oxygen + item_seed.produce_oxygen
		z_index = 0

	elif state == 'cool_down':
		z_index = -1
		animation = 'cool_down'
		var total_cool_down_time_sec = 5
		get_node('%count_down_timer').start(total_cool_down_time_sec)
		var each_frame_time = total_cool_down_time_sec /float(frames.get_frame_count('cool_down'))
		for i in frames.get_frame_count('cool_down'):
			get_node('%each_frame_timer').start(each_frame_time)
			yield(get_node('%each_frame_timer'),"timeout")
			frame = frame +1 
		self.state = 'default'

# Called when the node enters the scene tree for the first time.
func _ready():
	self.state = 'default'
	
func _on_player_area_mask_area_entered(area):
	if area.is_in_group('player'):
		player_in_area = area
		refesh_hight_list()

func _on_player_area_mask_area_exited(area):
	if area.is_in_group('player'):
		player_in_area = null
		refesh_hight_list()

func _on_player_area_mask_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('click') and player_in_area!=null:
		if state == 'default':
			get_node('/root/in_game').get_node('ui/player_inventory_list/player_inventory_list').close_player_inv()
			EffectManager.get_node('bong').play()
			get_node('/root/in_game').get_node('%mini_game_default').ground_farm = self
			get_node('/root/in_game').get_node('%mini_game_default').popup()
			
		elif state == 'dug':
			get_node('/root/in_game').get_node('ui/player_inventory_list/player_inventory_list').close_player_inv()
			EffectManager.get_node('bong').play()
			get_node('/root/in_game').get_node('%mini_game_dug').ground_farm = self
			get_node('/root/in_game').get_node('%mini_game_dug').popup()
			
		elif state == 'yield':
			get_node('/root/in_game').get_node('ui/player_inventory_list/player_inventory_list').close_player_inv()
			EffectManager.get_node('bong').play()
			get_node('/root/in_game').get_node('%mini_game_yield').ground_farm = self
			get_node('/root/in_game').get_node('%mini_game_yield').popup()
			
		elif state == 'seed':
			get_node('/root/in_game').get_node('ui/player_inventory_list/player_inventory_list').close_player_inv()
			EffectManager.get_node('bong').play()
			get_node('/root/in_game').get_node('%mini_game_seed').ground_farm = self
			get_node('/root/in_game').get_node('%mini_game_seed').popup()
		else:
			EffectManager.get_node('cant').play()
			
			
					
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
		material = shader_material
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		material = null
		Input.set_default_cursor_shape()
