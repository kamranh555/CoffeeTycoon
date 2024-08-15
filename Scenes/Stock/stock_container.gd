extends PanelContainer

var ingredient_name = ""
var purchase_quantity = 0
var increment = 5

@export var name_label : Label
@export var quantity_label : Label
@export var stock_icon : Sprite2D
@export var buy_quantity : Label
@export var cost_label : Label
@export var buy_button : Button
@export var add_button : Button
@export var less_button : Button

func _process(_delta):
	name_label.text = ingredient_name
	quantity_label.text = "Quantity: " + str(Global.stock_items[ingredient_name].stock) + "/" + str(Global.max_stock_capacity)
	buy_quantity.text = str(purchase_quantity)
	cost_label.text = "Cost: " + str(Global.format_cash(Global.stock_items[ingredient_name].cost * purchase_quantity / increment))
	stock_icon.frame = Global.stock_items[ingredient_name].iconID
	
	#Disable add button if quantity will exceed max limit
	if Global.stock_items[ingredient_name].stock + purchase_quantity + increment > Global.max_stock_capacity or Global.stock_items[ingredient_name].cost * (purchase_quantity + increment) / increment > Global.money  :
		add_button.disabled = true
	else : 
		add_button.disabled = false
	
	#Disable less button if its quantity is already zero
	if purchase_quantity > 0 :
		less_button.disabled = false
	else : 
		less_button.disabled = true
	
	#Disable buy button if cost greater than money or no items are selected
	if Global.stock_items[ingredient_name].cost * purchase_quantity / increment > Global.money or purchase_quantity == 0:
		buy_button.disabled = true
	else :
		buy_button.disabled = false
	

func _on_add_button_pressed():
	purchase_quantity += increment

func _on_less_button_pressed():
	if purchase_quantity >= increment:
		purchase_quantity -= increment

func _on_buy_button_pressed():
	if Global.purchase_ingredient(ingredient_name, purchase_quantity):
		purchase_quantity = 0
	# Add additional feedback for the player here
	
