class_name ItemRestoreEnergy extends BaseItem

export var buy_price:int = 5
export var restore_energy_point:int = 5

# return info of item thai lang
func get_info():
	return "ฟื้นฟูพลังงาน %s หน่วย"%restore_energy_point
