extends Control

var current_item_index = 0
var stand_name = ""
var upgrades_limit : int
@onready var list = Global.stand.keys()

var item_name_label
var item_info_label
var upgrade_button
var bonus_info_label
var display_image

func _ready():
	
	item_name_label = $MarginContainer/UpgradeImage/UpgradeText/Label
	item_info_label = $MarginContainer/UpgradeImage/UpgradeText/Info
	upgrade_button = $MarginContainer/UpgradeImage/UpgradeLevel/UpgradeButton
	bonus_info_label = $MarginContainer/UpgradeImage/UpgradeLevel/BonusInfo
	display_image = $MarginContainer/UpgradeImage/Container/Sprite2D
	
	# Update UI with the first item
	update_ui()

func update_ui():
	item_name_label.text = Global.stand[list[current_item_index]].name
	item_info_label.text = Global.stand[list[current_item_index]].info
	display_image.frame = Global.stand[list[current_item_index]].iconID
	bonus_info_label.text = "Upgrades limit: " + str(Global.stand[list[current_item_index]].bonus)
	upgrades_limit = Global.stand[list[current_item_index]].bonus


	if current_item_index < list.size()-1 :
		upgrade_button.text = Global.format_cash(Global.stand[list[current_item_index + 1]].cost) + "\n Upgrade"
	
	if current_item_index == list.size()-1 :
		upgrade_button.text = "Upgraded"
		upgrade_button.disabled = true

func _on_upgrade_button_pressed():
	var cost = Global.stand[list[current_item_index + 1]].cost
	if Global.money >= cost :
		Global.money -= cost
		Global.current_stand = Global.stand[list[current_item_index + 1]].name
		Global.current_upgrades_limit = Global.stand[list[current_item_index + 1]].bonus
		current_item_index += 1
		update_ui()
