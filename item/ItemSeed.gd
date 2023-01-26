class_name ItemSeed extends BaseItem

export var growth_time_sec:float = 5
export(Array,Texture) var grow_textrue_list:Array = []
export var product:Resource = GradientTexture2D.new()
export var produce_oxygen:int = 5
export var buy_price:int =5

func get_info()->String:
	return "ใช้เวลาปลูก %s วิ ให้ออกซิเจน %s และ ได้ผลผลิตเป็น %s ราคา %s ทอง"%[growth_time_sec,produce_oxygen,product.item_name,product.sell_price]
