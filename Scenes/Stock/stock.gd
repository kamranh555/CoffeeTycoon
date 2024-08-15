extends Control

@onready var ingredient_purchase_scene = preload("res://Scenes/Stock/stock_container.tscn")
@onready var ingredients_list = Global.unlocked_stocks
@export var grid_container : GridContainer

func _ready():
	Global.connect("update_stock_list", Callable(self, "display_stock"))
	display_stock()
	

func display_stock() :
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for ingredient in ingredients_list:
		
		var ingredient_instance = ingredient_purchase_scene.instantiate()
		ingredient_instance.ingredient_name = ingredient
		ingredient_instance.increment = Global.stock_items[ingredient].pack_quantity
		grid_container.add_child(ingredient_instance)
