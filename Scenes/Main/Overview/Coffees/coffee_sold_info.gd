extends Control

@onready var coffeesold_instance = preload("res://Scenes/Main/Overview/Coffees/coffee_sold_instance.tscn")
@onready var coffee_list = Global.unlocked_coffees
@export var grid_container : GridContainer

func _ready():
	Global.connect("update_coffees_count", Callable(self, "display_coffees"))
	display_coffees()

func display_coffees():
	
	for child in grid_container.get_children():
		child.queue_free()

	for coffee in coffee_list:
		
		var coffee_instance = coffeesold_instance.instantiate()
		coffee_instance.coffee_name = coffee
		grid_container.add_child(coffee_instance)
