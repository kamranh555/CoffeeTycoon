extends Control

var coffee_name = ""
var recipe_container = preload("res://Scenes/Coffees/recipe_container.tscn")

@export var name_label : Label
@export var coffee_icon : Sprite2D
@export var price_label : Label
@export var level_label : Label
@export var upgrade_button : Button
@export var special_toggle: CheckButton
@export var specials : HBoxContainer

func _ready():
	var container = $CoffeeContainer/RecipeContainer
	
	for ingredient in Global.coffee_types[coffee_name].recipe:
		var instance = recipe_container.instantiate()
		instance.coffee_name = coffee_name
		instance.stock_name = ingredient
		container.add_child(instance)
	
	#When coffee is already in specials, set specials button enabled
	special_toggle.button_pressed = coffee_name in Global.specials_list


func _process(_delta):
	name_label.text = coffee_name
	price_label.text = "Price: " + str(Global.format_cash(Global.coffee_types[coffee_name].price[Global.coffee_types[coffee_name].level]))
	level_label.text = "Lv. " + str(Global.coffee_types[coffee_name].level)
	coffee_icon.frame = Global.coffee_types[coffee_name].iconID
	
	#If 3 coffees have been selected, disable other toggles
	if Global.specials_list.size() >= 3 && special_toggle.button_pressed == false :
		special_toggle.disabled = true
	else:
		special_toggle.disabled = false

	if Global.specials_board == true :
		specials.visible = true
		custom_minimum_size.y = 180
	elif Global.specials_board == false :
		specials.visible = false
		custom_minimum_size.y = 160

func _on_upgrade_button_pressed():
	if Global.points >= 1:
		Global.points -= 1
		Global.coffee_types[coffee_name].level += 1
		if Global.coffee_types[coffee_name].level == 3:
			upgrade_button.disabled = true
			upgrade_button.text = "Upgraded"
		level_label.text = "Lv. " + str(Global.coffee_types[coffee_name].level)
	else:
		print("Not enough points to upgrade!")


func _on_check_button_toggled(toggled_on):
	if toggled_on :
		Global.specials_list.append(coffee_name)
	else : 
		Global.specials_list.erase(coffee_name)
