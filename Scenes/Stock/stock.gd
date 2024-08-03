extends Control

@onready var ingredient_purchase_scene = preload("res://Scenes/Stock/stock_container.tscn")
@onready var ingredients_list = Global.stock_items.keys()
@export var grid_container : GridContainer

func _ready():
	for ingredient in ingredients_list:
		var ingredient_instance = ingredient_purchase_scene.instantiate()
		ingredient_instance.ingredient_name = ingredient
		ingredient_instance.increment = Global.stock_items[ingredient].pack_quantity
		grid_container.add_child(ingredient_instance)
