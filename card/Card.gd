class_name Card extends Resource

export var card_name:String
export(String, MULTILINE) var desc:String
export var pic:Texture

export var buff_energy:int
export var buff_oxygen:int
export var buff_move_speed:int
export(Array,Resource) var buff_start_item:Array


func get_buff_info() -> String:
	var buff_str = "โบนัส:\n"
	if buff_energy != 0:
		buff_str += "พลังงาน: +" + str(buff_energy) + "\n"
	if buff_oxygen != 0:
		buff_str += "ออกซิเจน: +" + str(buff_oxygen) + "\n"
	if buff_move_speed != 0:
		buff_str += "ความเร็วเคลื่อนที่: +" + str(buff_move_speed) + "\n"
	if buff_start_item.size() > 0:
		buff_str += "ไอเทมเริิ่มต้น: \n"
		for item in buff_start_item:
			buff_str += "- " + item.item_name + "\n"
	return buff_str
