extends PopupDialog

export(Array,Resource) var sell_item_list:Array
var queue_item_dict:Dictionary
var sell_item_dict:Dictionary
var is_no_shop_drop_box := true

func _ready():
	refesh()
		
func _on_dialog_end(timeline_name,dialog):
	Profile.is_first_time_in_shop = false
	get_tree().paused = false
	dialog.queue_free()

func dialog_listener(string):
	match string:
		"somthing":
			pass

func _process(delta):
	if get_node("%delivery_timer").time_left >0:
		get_node("%delivery_time_label").text = '%2d'%get_node("%delivery_timer").time_left

func refesh():
	var index
	var old_select_indedx
	
	old_select_indedx = $"%can_buy_item_list".get_selected_items()[0] if not $"%can_buy_item_list".get_selected_items().empty() else null
	index = 0
	get_node('%can_buy_item_list').clear()
	for item in sell_item_list:
		get_node('%can_buy_item_list').add_item('%s %s ทอง'%[item.item_name,item.buy_price],item.icon)
		get_node('%can_buy_item_list').set_item_tooltip(index,item.get_info())
		index = index +1
	if old_select_indedx != null:
		$"%can_buy_item_list".select(old_select_indedx,true)
		
	old_select_indedx = $"%waing_item_list".get_selected_items()[0] if not $"%waing_item_list".get_selected_items().empty() else null
	index=0
	get_node('%waing_item_list').clear()
	for item in queue_item_dict:
		get_node('%waing_item_list').add_item('%s X%s'%[item.item_name,queue_item_dict[item]],item.icon)
		get_node('%waing_item_list').set_item_tooltip(index,'ราคารวม %s ทอง'%[item.buy_price*queue_item_dict[item]])
		index = index +1
	if old_select_indedx != null:
		if old_select_indedx+1 <= $"%waing_item_list".get_item_count():
			$"%waing_item_list".select(old_select_indedx,true)
		
	index=0
	get_node('%wating_sell_item_list').clear()
	for item in sell_item_dict:
		get_node('%wating_sell_item_list').add_item('%s X%s'%[item.item_name,sell_item_dict[item]],item.icon)
		get_node('%wating_sell_item_list').set_item_tooltip(index,'ราคารวม %s ทอง'%[item.sell_price*sell_item_dict[item]])
		index = index +1
	
	$"%money_label".text = str( get_node('/root/in_game').money)
	
	if $"%can_buy_item_list".get_selected_items().empty():
		$buy_button.disabled = true
	
	if $"%waing_item_list".get_selected_items().empty():
		$cancel_button.disabled = true
		
		
func _on_delivery_timer_timeout():
#	if not queue_item_dict.empty():
#		var shop_drop_box_instance
#		var shop_drop_box_group = get_tree().get_nodes_in_group('shop_drop_box_group')[0]
#		if shop_drop_box_group.get_child_count() <=1:
#			shop_drop_box_instance = load('res://shop_drop_box/shop_drop_box.tscn').instance()
#			shop_drop_box_group.add_child(shop_drop_box_instance)
#		else:
#			shop_drop_box_instance = shop_drop_box_group.get_child(1)
#		var inventory = shop_drop_box_instance.get_node('%inventory')
#		for item in queue_item_dict:
#			for i in queue_item_dict[item]:
#				inventory.add_item(item)
#		queue_item_dict.clear()
#
#	if not sell_item_dict.empty():
#		var totol_money = 0
#		for item in sell_item_dict:
#			totol_money = totol_money + item.sell_price*sell_item_dict[item]
#		get_node('/root/in_game').money = get_node('/root/in_game').money+totol_money
#		sell_item_dict.clear()
#	refesh()
	pass


func _on_can_buy_item_list_item_activated(index):
	buy_item(index)

func _on_waing_item_list_item_activated(index):
	cancle_buy_item(index)

func _on_cancle_all_button_pressed():
	EffectManager.get_node("ui_cancel").play()
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
	#dialog event
	yield(get_tree(),"idle_frame")
	if Profile.is_first_time_in_shop:
		get_tree().paused = true
		var dialog = Dialogic.start('shop')
		yield(get_tree().create_timer(1),"timeout")
		dialog.pause_mode = PAUSE_MODE_PROCESS
		add_child(dialog)
		dialog.connect('timeline_end',self,'_on_dialog_end',[dialog])
		dialog.connect("dialogic_signal", self, "dialog_listener")

func _on_shop_menu_popup_hide():
	get_tree().get_nodes_in_group('player')[0].is_can_move = true

func _on_exit_button_pressed():
	EffectManager.get_node("ui_cancel").play()
	hide()

func _on_can_buy_item_list_item_selected(index):
	$buy_button.disabled = false

func _on_waing_item_list_item_selected(index):
	$cancel_button.disabled = false

func buy_item(index):
	EffectManager.get_node("coins").play()
	var item = sell_item_list[index]
	if get_node('/root/in_game').money >= item.buy_price:
		get_node('/root/in_game').money = get_node('/root/in_game').money - item.buy_price
		if not queue_item_dict.has(item):
			queue_item_dict[item] = 1
		else:
			queue_item_dict[item] = queue_item_dict[item]+1
	refesh()
	
func cancle_buy_item(index):
	EffectManager.get_node("ui_cancel").play()
	var item = queue_item_dict.keys()[index]
	get_node('/root/in_game').money = get_node('/root/in_game').money + item.buy_price
	queue_item_dict[item] = queue_item_dict[item]-1
	if queue_item_dict[item] <=0:
		queue_item_dict.erase(item)
	refesh()

func _on_buy_button_pressed():
	buy_item($"%can_buy_item_list".get_selected_items()[0])

func _on_cancel_button_pressed():
	cancle_buy_item($"%waing_item_list".get_selected_items()[0])

func _on_sumit_button_pressed():
	if not queue_item_dict.empty() and is_no_shop_drop_box:
		EffectManager.get_node("bong").play()
		is_no_shop_drop_box = false
		var shop_drop_box_group = get_tree().get_nodes_in_group('shop_drop_box_group')[0]
		var shop_drop_box_instance = load('res://shop_drop_box/shop_drop_box.tscn').instance()
		shop_drop_box_group.add_child(shop_drop_box_instance)
		var inventory = shop_drop_box_instance.get_node('%inventory')
		for item in queue_item_dict:
			for i in queue_item_dict[item]:
				inventory.add_item(item)
		queue_item_dict.clear()
		hide()
		refesh()
	else:
		EffectManager.get_node("ui_cancel").play()


func _on_sell_button_pressed():
	EffectManager.get_node("bong").play()
	print(sell_item_dict)
	if not sell_item_dict.empty():
		var totol_money = 0
		for item in sell_item_dict:
			totol_money = totol_money + item.sell_price*sell_item_dict[item]
		get_node('/root/in_game').money = get_node('/root/in_game').money+totol_money
		sell_item_dict.clear()
		refesh()
		
		

