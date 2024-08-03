extends Control

@onready var coffee_container_scene = preload("res://Scenes/Coffees/coffee_container.tscn")
@onready var coffee_list = Global.coffee_types.keys()
@export var specials_label : Label
@export var grid_container : GridContainer

func _ready():
	
	for coffee in coffee_list:
		var coffee_instance = coffee_container_scene.instantiate()
		coffee_instance.coffee_name = coffee
		grid_container.add_child(coffee_instance)

func _process(_delta):
	
	if Global.specials_board == true :
		specials_label.visible = true
	elif Global.specials_board == false :
		specials_label.visible = false
	
	specials_label.text = "Specials: " + str(Global.specials_list.size()) + "/3"
