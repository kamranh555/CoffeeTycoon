extends Control

var current_item_index = 0
var grinder_name = ""
@onready var list = Global.grinders.keys()

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
	item_name_label.text = Global.grinders[list[current_item_index]].name
	item_info_label.text = Global.grinders[list[current_item_index]].info
	display_image.frame = Global.grinders[list[current_item_index]].iconID
	bonus_info_label.text = "Quality: +" + str(Global.grinders[list[current_item_index]].quality)



	if current_item_index < list.size()-1 :
		upgrade_button.text = Global.format_cash(Global.grinders[list[current_item_index + 1]].cost) + "\n Upgrade"
	
	if current_item_index == list.size()-1 :
		upgrade_button.text = "Fully upgraded"
		upgrade_button.disabled = true

func _on_upgrade_button_pressed():
	var cost = Global.grinders[list[current_item_index + 1]].cost
	if Global.money >= cost :
		Global.money -= cost
		Global.current_grinder = Global.grinders[list[current_item_index + 1]].name
		Global.grinder_level = Global.grinders[list[current_item_index + 1]].quality
		current_item_index += 1
		update_ui()
