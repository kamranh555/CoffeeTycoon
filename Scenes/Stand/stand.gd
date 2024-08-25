extends Control

@export var stand : PanelContainer
@onready var upgrades_list = Global.upgrades_owned.keys()

@export var stand_container : VBoxContainer
@export var stand_btn : Button
@export var upgrades_btn : Button
@export var upgrades_container : PanelContainer
@export var header : Label
@export var upgrades_header : Label

func _ready():
	upgrades_header.text = "Upgrades owned: " + str(upgrades_list.size()) + "/" + str(Global.current_upgrades_limit)

func _process(_delta):
	upgrades_list = Global.upgrades_owned.keys()
	upgrades_header.text = "Stand upgrades owned: " + str(upgrades_list.size()) + "/" + str(Global.current_upgrades_limit)
	
	if header.text == "STAND":
		stand_btn.disabled = true
		upgrades_btn.disabled = false
	elif header.text == "UPGRADES" :
		upgrades_btn.disabled = true
		stand_btn.disabled = false

func _on_stand_btn_pressed() -> void:
	header.text = "STAND"


func _on_upgrades_btn_pressed() -> void:
	header.text = "UPGRADES"
