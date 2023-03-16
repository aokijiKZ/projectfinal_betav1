extends Panel

var card_index



func can_drop_data(position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("card_index")

func drop_data(position, data):
	self.card_index = data["card_index"]
	var card_data = $"..".card_data_list[self.card_index]
	$card_display.get_node("card").texture = data["card_pic"]
	$"../detail/desc_panel/desc".text =  card_data.desc
	$"../detail/buff_panel/buff".text = card_data.get_buff_info()
	EffectManager.get_node("hit").play()
	Profile.current_card_path = card_data.resource_path
