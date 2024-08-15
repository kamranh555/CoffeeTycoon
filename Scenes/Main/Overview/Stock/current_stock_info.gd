extends Control

@onready var stockinfo_instance = preload("res://Scenes/Main/Overview/Stock/stock_info_instance.tscn")
@onready var current_stock_list = Global.unlocked_stocks
@export var grid_container : GridContainer

func _ready():
	Global.connect("update_stock_list", Callable(self, "display_stock"))
	display_stock()

func display_stock() :
	
	for child in grid_container.get_children():
		child.queue_free()

	for stock in current_stock_list:
		
		var stock_instance = stockinfo_instance.instantiate()
		stock_instance.stock_name = stock
		grid_container.add_child(stock_instance)
