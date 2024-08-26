extends PanelContainer

var current_index = 0
var location_name = ""
@onready var list = Global.locations.keys()

@export var name_label : Label
@export var info_label : Label
@export var back_button  : Button
@export var forward_button  : Button
@export var select_button  : Button
@export var permit_label : Label
@export var display_image : Sprite2D

func _ready():
	# Update UI with the first item
	update_ui()

func update_ui():
	name_label.text = Global.locations[list[current_index]].name
	info_label.text = Global.locations[list[current_index]].info
	back_button.disabled = current_index == 0
	forward_button.disabled = current_index == list.size() - 1
	select_button.disabled = Global.current_location == current_index
	display_image.frame = Global.locations[list[current_index]].iconID
	permit_label.text = "Rent per day: " + Global.format_cash(Global.locations[list[current_index]].permit_cost)
	
	if Global.current_location == current_index :
		select_button.disabled = true
		select_button.text = "Selected"
	else : 
		select_button.text = "Select"

func _on_forward_button_pressed():
	current_index += 1
	update_ui()

func _on_back_button_pressed():
	current_index -= 1
	update_ui()

func _on_select_button_pressed() -> void:
	Global.current_location = current_index
	Global.location_name = Global.locations[list[current_index]].name
	Global.update_location.emit()
	update_ui()
