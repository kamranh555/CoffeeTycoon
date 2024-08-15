extends PanelContainer

var current_item_index = 0
var advertisement_name = ""
@onready var list = Global.advertisements.keys()

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
	item_name_label.text = Global.advertisements[list[current_item_index]].name
	item_info_label.text = Global.advertisements[list[current_item_index]].info
	back_button.disabled = current_item_index == 0
	forward_button.disabled = current_item_index == list.size() - 1
	buy_button.disabled = Global.money < Global.advertisements[list[current_item_index]].cost
	buy_button.text = Global.format_cash(Global.advertisements[list[current_item_index]].cost) + "\n Buy"
	display_image.frame = Global.advertisements[list[current_item_index]].iconID
	
	if Global.advertisements[list[current_item_index]].days_left > 0 :
		buy_button.disabled = true
		buy_button.text = "Active, days left: " + str(Global.advertisements[list[current_item_index]].days_left)
	
func _on_forward_button_pressed():
	current_item_index += 1
	update_ui()

func _on_back_button_pressed():
	current_item_index -= 1
	update_ui()

func _on_upgrade_button_pressed():
	var cost = Global.advertisements[list[current_item_index]].cost
	if Global.money >= cost:
		Global.money -= cost
		Global.report_td["marketing"] -= cost
		Global.advertisements[list[current_item_index]].days_left = 7
		update_ui()

