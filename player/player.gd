extends KinematicBody2D

#stat
var max_energy := 10 setget set_max_energy
var energy := max_energy setget set_energy
var is_can_cosume_energy := true

var max_oxygen :=10 setget set_max_oxygen
var oxygen := max_oxygen setget set_oxygen


#movement
var move_speed := 16*3 setget set_move_speed
var velocity := Vector2(0, 0)
var is_can_move := true

#talk
var is_ready_to_talk := true

signal energy_changed(energy,max_energy)

func _ready():
	refesh_energy_bar()
	refesh_oxygen_bar()
	refesh_ingame_player_energy_bar_bar()
	refesh_ingame_player_energy_label()

func _physics_process(delta):
	if is_can_move:
		var x_input = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		var y_input = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		
		velocity = Vector2(x_input, y_input).normalized()
		if velocity.x < 0:
			get_node('%animated_sprite').flip_h = true
			get_node('%animated_sprite').play("move_right")
		elif  velocity.x > 0:
			get_node('%animated_sprite').flip_h = false
			get_node('%animated_sprite').play("move_right")
		elif velocity.y<0:
			get_node('%animated_sprite').flip_h = false
			get_node('%animated_sprite').play("move_up")
		elif velocity.y>0:
			get_node('%animated_sprite').flip_h = false
			get_node('%animated_sprite').play("move_down")
		else:
			get_node('%animated_sprite').flip_h = false
			get_node('%animated_sprite').play("idle")
		
		move_and_slide(velocity * move_speed)

func set_energy(v):
	if is_can_cosume_energy:
		energy = v
		if energy<=0:
			talk('เหนื่อย')
	else:
		energy = max_energy
	refesh_energy_bar()
	refesh_ingame_player_energy_bar_bar()
	refesh_ingame_player_energy_label()
	emit_signal("energy_changed",energy,max_energy)
	
func talk(conversation:String):
	if is_ready_to_talk:
		is_ready_to_talk = false
		var conversation_node = get_node("%conversation")
		conversation_node.percent_visible = 0.0
		conversation_node.text = conversation
		var tween = get_tree().create_tween()
		tween.tween_property(conversation_node, "percent_visible", 1.0, 1)
		tween.tween_property(conversation_node, "percent_visible", 0.0, 1).set_delay(2)
		tween.tween_property(self, "is_ready_to_talk", true, 0)

func unlimit_energy(time):
	is_can_cosume_energy = false
	energy = max_energy
	refesh_energy_bar()
	refesh_ingame_player_energy_bar_bar()
	yield(get_tree().create_timer(time),"timeout")
	is_can_cosume_energy = true
	refesh_energy_bar()
	refesh_ingame_player_energy_bar_bar()
	refesh_ingame_player_energy_label()

func refesh_energy_bar():
	get_node("5_z_index/energy_bar").value = energy/float(max_energy) * 100
	get_node("5_z_index/energy_bar").hint_tooltip = str(energy)+'/'+str(max_energy)
	if is_can_cosume_energy == false:
		get_node("5_z_index/energy_bar").modulate = Color(5,5,5,5)
	else:
		get_node("5_z_index/energy_bar").modulate = Color(1,1,1,1)

func refesh_ingame_player_energy_bar_bar():
	$"../../ui/player_energy_bar".value = energy/float(max_energy) * (100)

func refesh_ingame_player_energy_label():
	$"../../ui/player_energy_label".text = '%s/%s'%[energy,max_energy]

func set_oxygen(v):
	oxygen = v
	if oxygen <=0:
		get_node('/root/in_game').failed_game()
	refesh_oxygen_bar()


	
func refesh_oxygen_bar():
	get_node("5_z_index/oxygen_bar").value = oxygen/float(max_oxygen) * 100
	get_node("5_z_index/oxygen_bar").hint_tooltip = str(oxygen)+'/'+str(max_oxygen)

func _on_oxygen_timer_timeout():
	self.oxygen = oxygen-1
	
func set_max_energy(v):
	max_energy = v
	self.energy = max_energy

func set_max_oxygen(v):
	max_oxygen = v
	self.oxygen = max_oxygen

func set_move_speed(v):
	move_speed = v
	
