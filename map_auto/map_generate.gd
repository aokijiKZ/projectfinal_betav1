tool
extends Node

export var money := 1000
export var target_time_sec := 60
export var target_oxygen :=  10
export var unlock_oxygen_theshold :=0
export var card_reward :Resource

var map_size = Vector2(25, 25)
var tile_size = Vector2(64, 64)

export var no_generate_area = Vector2(10, 10)
export var border_size = Vector2(10,10)
var steps = 1000
var map_data = {}
var walk_path = []


enum Direction { UP, DOWN, LEFT, RIGHT }

enum Tiles {
	EMPTY = -1,
	GROUND = 3,
	WATER = 2
}

export(bool) var regenerate := false setget set_regenerate

func set_regenerate(value):
	regenerate = value
	if regenerate and Engine.editor_hint:
		generate_map()
		regenerate = false

func generate_map():
	var chest_count := 0
	var chest_limit :=0
	var ground_tile_map :=$ground_tile_map
	var water_tile_map := $water_tile_map
	var obejct_group = $obejct_group
	
	#clear
	ground_tile_map.clear()
	water_tile_map.clear()
	for c in obejct_group.get_children():
		c.queue_free()
			
	for x in range(-border_size.x,map_size.x+border_size.x,1):
		for y in range(-border_size.y,map_size.y+border_size.y,1):
			water_tile_map.set_cell(x, y, Tiles.WATER)
	
	
	var start_position = Vector2(int(map_size.x/2), int(map_size.y/2))
	var current_position = start_position
	
	for step in range(steps):
		
		
		#draw ground
		var draw_offset = Vector2.ZERO
		if step == 0:
			draw_offset = no_generate_area
		else:
			draw_offset = Vector2(2,2)
		
		for p_x in range(-draw_offset.x,draw_offset.x,1):
			for p_y in range(-draw_offset.y,draw_offset.y,1):
				ground_tile_map.set_cell(clamp(current_position.x+p_x,0,map_size.x-1),clamp(current_position.y+p_y,0,map_size.y-1),Tiles.GROUND)
		
		
		randomize()
		var direction = randi() % 4

		match direction:
			Direction.UP:
				current_position.y -= 1
			Direction.DOWN:
				current_position.y += 1
			Direction.LEFT:
				current_position.x -= 1
			Direction.RIGHT:
				current_position.x += 1
		
		current_position.x = clamp(current_position.x,0,map_size.x-1)
		current_position.y = clamp(current_position.y,0,map_size.y-1)
		
		if not map_data.has(current_position):
			map_data[current_position] = 1
			walk_path.append(current_position)
		
		
		var is_in_no_gen_area = false
		if current_position.x<(start_position.x+no_generate_area.x)and current_position.x>(start_position.x-no_generate_area.x) and current_position.y<(start_position.y+no_generate_area.y) and current_position.y>(start_position.y-no_generate_area.y):
			is_in_no_gen_area = true
		var is_already_has_obj = false
		for c in obejct_group.get_children():
			var pre_object_position = Vector2(clamp(current_position.x,1,map_size.x-2),clamp(current_position.y,1,map_size.y-2))
			pre_object_position = Vector2(pre_object_position.x*16+8,pre_object_position.y*16+8)
			if c.position == pre_object_position:
				is_already_has_obj = true
		if (not is_already_has_obj) and (not is_in_no_gen_area):
			#draw object
			if randf() < 0.02: #draw tree
				add_object("res://tree/tree.tscn",current_position)
			elif randf() <0.01: #draw rock
				add_object("res://rock/rock.tscn",current_position)

	ground_tile_map.update_bitmask_region()
	water_tile_map.update_bitmask_region()
	$player.position = Vector2(start_position.x*16+8,start_position.y*16+8)
	
func add_object(obejct_path:String,position:=Vector2.ZERO):
	var obj_position = Vector2.ZERO
	obj_position.x = clamp(position.x,1,map_size.x-2)
	obj_position.y = clamp(position.y,1,map_size.y-2)
	obj_position = Vector2(obj_position.x*16+8,obj_position.y*16+8)
	var obejct_group = $obejct_group
	var obj_ins = load(obejct_path).instance()
	obejct_group.add_child(obj_ins)
	obj_ins.set_owner(get_tree().get_edited_scene_root())
	obj_ins.position = Vector2(obj_position)
	

func _ready():
	if not Engine.editor_hint:
		return
	
