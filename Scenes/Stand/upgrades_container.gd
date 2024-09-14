extends PanelContainer

var current_item_index = 0
var upgrade_name = ""
@onready var list = Global.upgrades.keys()
@onready var upgrades_list = Global.upgrades_owned.keys()

@export var item_name_label : Label
@export var item_info_label : Label
@export var back_button  : Button
@export var forward_button  : Button
@export var buy_button  : Button
@export var bonus_info_label : Label
@export var display_image : Sprite2D

func _ready():
	# Update UI with the first item
	update_ui()

func update_ui():
	item_name_label.text = Global.upgrades[list[current_item_index]].name
	item_info_label.text = Global.upgrades[list[current_item_index]].info
	back_button.disabled = current_item_index == 0
	forward_button.disabled = current_item_index == list.size() - 1
	buy_button.disabled = Global.money < Global.upgrades[list[current_item_index]].cost
	buy_button.text = Global.format_cash(Global.upgrades[list[current_item_index]].cost) + "\n Buy"
	display_image.frame = Global.upgrades[list[current_item_index]].iconID
	upgrades_list = Global.upgrades_owned.keys()
	
	if Global.upgrades_owned.has(Global.upgrades[list[current_item_index]].name) :
		buy_button.disabled = true
		buy_button.text = "Owned"
	
	if !Global.upgrades_owned.has(Global.upgrades[list[current_item_index]].name) && upgrades_list.size() >= Global.current_upgrades_limit :
		buy_button.disabled = true
		
	if !Global.upgrades_owned.has(Global.upgrades[list[current_item_index]].name) && upgrades_list.size() < Global.current_upgrades_limit :
		buy_button.disabled = false

func _on_forward_button_pressed():
	current_item_index += 1
	update_ui()

func _on_back_button_pressed():
	current_item_index -= 1
	update_ui()

func _on_upgrade_button_pressed():
	var cost = Global.upgrades[list[current_item_index]].cost
	if Global.money >= cost:
		Global.money -= cost
		Global.upgrades_owned[Global.upgrades[list[current_item_index]].name] = Global.upgrades[list[current_item_index]]
		update_ui()
		Global.increase_attraction(Global.upgrades[list[current_item_index]].name)
		Global.increase_queue_size(Global.upgrades[list[current_item_index]].name)
		Global.rain_protection(Global.upgrades[list[current_item_index]].name)
		Global.faster_service(Global.upgrades[list[current_item_index]].name)
		Global.increase_stock_capacity(Global.upgrades[list[current_item_index]].name)
		Global.specials_board_purchased(Global.upgrades[list[current_item_index]].name)
