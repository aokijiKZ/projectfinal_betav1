extends ViewportContainer

func _ready():
	pass
	

func capture(scene_path):
	var viewport_instance = Viewport.new()
	add_child(viewport_instance)
	viewport_instance.size = Vector2(960,540)
	var scene_instance = load(scene_path).instance()
	viewport_instance.add_child(scene_instance)
	yield(get_tree(),"idle_frame")
	yield(VisualServer,"frame_post_draw")
	viewport_instance.update_worlds()
	var img = viewport_instance.get_viewport().get_texture().get_data()
	img.flip_y()
	img.save_png('%s.png'%scene_path.get_basename())
	yield(get_tree().create_timer(0.5),"timeout")
	viewport_instance.queue_free()
