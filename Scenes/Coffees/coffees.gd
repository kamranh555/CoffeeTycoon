extends Control

@onready var coffee_container_scene = preload("res://Scenes/Coffees/coffee_container.tscn")
@onready var all_coffees = Global.coffee_types.keys()
@export var specials_label : Label
@export var grid_container : GridContainer

func _ready():
	
	update_list()
	
func update_list() :
	
	#delete current children in the grid to update to new grid
	for child in grid_container.get_children():
		child.queue_free()
	
	# Clear the current coffee_list to avoid duplicates
	Global.unlocked_coffees.clear()
	
	# Initialize the variable to track the first locked item
	var first_locked_coffee = null
	
	# Iterate through each coffee in all_coffees
	for coffee in all_coffees : 
		if Global.coffee_types[coffee].unlocked == true :
			# If the coffee is unlocked, add it to the coffee_list
			Global.unlocked_coffees.append(coffee)
			Global.emit_signal("update_coffees_count")
			
			#add list of ingredients to a list of unlocked stocks
			for ingredient in Global.coffee_types[coffee].recipe:
				if !Global.unlocked_stocks.has(ingredient) :
					Global.unlocked_stocks.append(ingredient)
					Global.emit_signal("update_stock_list")
			
		elif first_locked_coffee == null : 
			# If the coffee is locked and we haven't found a locked item yet,
			# set first_locked_item to the current coffee
			first_locked_coffee = coffee
			
			
	# After the loop, check if there was a locked item
	if first_locked_coffee != null:
		# If there was a locked item, add it to the coffee_list
		Global.unlocked_coffees.append(first_locked_coffee)
		
	#Instantiate the coffees that are to be displayed
	instantiate_coffees()

func instantiate_coffees() :
	for coffee in Global.unlocked_coffees:
		var coffee_instance = coffee_container_scene.instantiate()
		coffee_instance.coffee_name = coffee
		grid_container.add_child(coffee_instance)
		coffee_instance.connect("update_coffee_list", Callable(self, "update_list"))


func _process(_delta):
	
	if Global.specials_board == true :
		specials_label.visible = true
	elif Global.specials_board == false :
		specials_label.visible = false
	
	specials_label.text = "Specials: " + str(Global.specials_list.size()) + "/3"
