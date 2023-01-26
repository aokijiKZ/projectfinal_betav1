extends PopupDialog

export(Array,Resource) var sell_item_list:Array
var queue_item_dict:Dictionary
var sell_item_dict:Dictionary

func _ready():
	refesh()

func _process(delta):
	if get_node("%delivery_timer").time_left >0:
		get_node("%delivery_time_label").text = '%2d'%get_node("%delivery_timer").time_left

func refesh():
	get_node('%can_buy_item_list').clear()
	var index=0
	for item in sell_item_list:
		get_node('%can_buy_item_list').add_item('%s %s ทอง'%[item.item_name,item.buy_price],item.icon)
		get_node('%can_buy_item_list').set_item_tooltip(index,item.get_info())
		index = index +1
	get_node('%waing_item_list').clear()
	index=0
	for item in queue_item_dict:
		get_node('%waing_item_list').add_item('%s X%s'%[item.item_name,queue_item_dict[item]],item.icon)
		get_node('%waing_item_list').set_item_tooltip(index,'ราคารวม %s ทอง'%[item.buy_price*queue_item_dict[item]])
		index = index +1
	get_node('%wating_sell_item_list').clear()
	index=0
	for item in sell_item_dict:
		get_node('%wating_sell_item_list').add_item('%s X%s'%[item.item_name,sell_item_dict[item]],item.icon)
		get_node('%wating_sell_item_list').set_item_tooltip(index,'ราคารวม %s ทอง'%[item.sell_price*sell_item_dict[item]])
		index = index +1
		
func _on_delivery_timer_timeout():
#	var inventory = get_tree().get_nodes_in_group('player_inventory')[0]
	if not queue_item_dict.empty():
		var shop_drop_box_instance
		var shop_drop_box_group = get_tree().get_nodes_in_group('shop_drop_box_group')[0]
		if shop_drop_box_group.get_child_count() <=0:
			shop_drop_box_instance = load('res://shop_drop_box/shop_drop_box.tscn').instance()
			shop_drop_box_group.add_child(shop_drop_box_instance)
		else:
			shop_drop_box_instance = shop_drop_box_group.get_child(0)
		var inventory = shop_drop_box_instance.get_node('%inventory')
		for item in queue_item_dict:
			for i in queue_item_dict[item]:
				inventory.add_item(item)
		queue_item_dict.clear()
	
	if not sell_item_dict.empty():
		var totol_money = 0
		for item in sell_item_dict:
			totol_money = totol_money + item.sell_price*sell_item_dict[item]
		get_node('/root/in_game').money = get_node('/root/in_game').money+totol_money
		sell_item_dict.clear()
	refesh()


func _on_can_buy_item_list_item_activated(index):
	var item = sell_item_list[index]
	if get_node('/root/in_game').money >= item.buy_price:
		get_node('/root/in_game').money = get_node('/root/in_game').money - item.buy_price
		if not queue_item_dict.has(item):
			queue_item_dict[item] = 1
		else:
			queue_item_dict[item] = queue_item_dict[item]+1
	refesh()


func _on_waing_item_list_item_activated(index):
	var item = queue_item_dict.keys()[index]
	get_node('/root/in_game').money = get_node('/root/in_game').money + item.buy_price
	queue_item_dict[item] = queue_item_dict[item]-1
	if queue_item_dict[item] <=0:
		queue_item_dict.erase(item)
	refesh()


func _on_cancle_all_button_pressed():
	for item in queue_item_dict:
		get_node('/root/in_game').money = get_node('/root/in_game').money + item.buy_price
		print_debug(item)
	queue_item_dict.clear()
	refesh()


func _on_shop_menu_about_to_show():
	get_tree().get_nodes_in_group('player')[0].is_can_move = false
	var player = get_tree().get_nodes_in_group('player')[0]
	for item in player.get_node('%inventory').get_item_dict():
		if 'sell_price' in item:
			if not sell_item_dict.has(item):
				sell_item_dict[item] = player.get_node('%inventory').get_item_dict()[item]
			else:
				sell_item_dict[item] = sell_item_dict[item]+player.get_node('%inventory').get_item_dict()[item]
			player.get_node('%inventory').erase_item(item)
	refesh()

func _on_shop_menu_popup_hide():
	get_tree().get_nodes_in_group('player')[0].is_can_move = true

