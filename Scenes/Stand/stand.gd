extends Control

@export var stand : PanelContainer
@onready var upgrades_list = Global.upgrades_owned.keys()

@export var stand_container : VBoxContainer
@export var back_button : Button
@export var upgrades_container : PanelContainer
@export var header : Label
@export var upgrades_header : Label

func _ready():
	upgrades_header.text = "Upgrades owned: " + str(upgrades_list.size()) + "/" + str(Global.current_upgrades_limit)

func _process(_delta):
	upgrades_list = Global.upgrades_owned.keys()
	upgrades_header.text = "Stand upgrades owned: " + str(upgrades_list.size()) + "/" + str(Global.current_upgrades_limit)


func _on_upgrades_button_pressed():
	stand_container.visible = false
	upgrades_container.visible = true
	back_button.visible = true
	header.text = "UPGRADES"
	


func _on_back_button_pressed():
	stand_container.visible = true
	upgrades_container.visible = false
	back_button.visible = false
	header.text = "STAND"
