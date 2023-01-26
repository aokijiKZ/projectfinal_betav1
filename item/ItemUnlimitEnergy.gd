class_name ItemUnlimitEnergy extends BaseItem

export var buy_price:int = 10
export var unlimit_energy_time_sec:int =5

func get_info():
	return "ฟื้นฟูพลังเต็มและยังสามารถใช้ได้ไม่จำกัด ภายในเวลา "+str(unlimit_energy_time_sec)+" วิ"
