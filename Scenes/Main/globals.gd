extends Node

# Global variables accessible across scripts
var money = 500
var base_demand = 25
var popularity = 0
var people_queue = []
var stock_current = 0
var points = 5
var experience = 0

# Date and time
var date = {
	"year": 1,
	"season": 0,
	"day": 1,
	"day_of_week": 0  # We'll use this to keep track of the day of the week
}
# Season names
var seasons = {
	0: "Spr",
	1: "Sum",
	2: "Fal",
	3: "Win"
}
# Days of the week
var days_of_week = {
	0: "Mon",
	1: "Tue",
	2: "Wed",
	3: "Thu",
	4: "Fri",
	5: "Sat",
	6: "Sun"
}
# Weather probabilities for each season
var current_weather = ""
var weather_probabilities = {
	"Spr": {"rain": 0.25, "snow": 0.0},
	"Sum": {"rain": 0.1, "snow": 0.0},
	"Fal": {"rain": 0.4, "snow": 0.0},
	"Win": {"rain": 0.0, "snow": 0.3}  # 30% chance of snow in winter
}

#Stands
var base_upgrades_limit = 3
var current_upgrades_limit = 3

#Impacted by upgrades:
#region Upgrades
var base_serve_time = 2.00
var serving_time = 2.00
var base_coffee_speed = 3.00
var coffee_speed = 3.00
var base_quality = 20
var grinder_level = 0
var base_queue_limit = 5
var queue_limit = 5
var rain_queue_base = 3
var rain_queue_limit = 3
var ice_creation = 0
var refridgerate = 0
var attraction = 0
var specials_board = false
var max_stock_capacity = 25
var social_media_followers = 0
var total_posts = 0
var current_post_likes = 0
var ad_boost = 0
#endregion

#Upgradeable skills
var skills = {}

#region Variables to define databases
var coffee_types: Dictionary = {}
var unlocked_coffees: Array = []
signal update_coffees_count
var specials_list: Array = []
var stock_items: Dictionary = {}
var unlocked_stocks : Array = ["Cups"]
signal update_stock_list
var upgrades: Dictionary = {}
var upgrades_owned: Dictionary = {}
var current_stand = "Basic Cart"
var stand: Dictionary = {}
var grinders: Dictionary = {}
var current_grinder = "None"
var espresso_machines: Dictionary = {}
var current_espresso_machine = "None"
var advertisements: Dictionary = {}
#endregion

# Define demand modifiers based on season
var demand_adjustments = {
		"Classic": {"Win": 0.5, "Spr": 0.5, "Sum": 0.5, "Fal": 0.5},
		"Cold Brew": {"Win": 0.1, "Spr": 0.5, "Sum": 1.0, "Fal": 0.25},
		"Fruity": {"Win": 0.25, "Spr": 1.0, "Sum": 0.25, "Fal": 0.25},
		"Spiced": {"Win": 0.25, "Spr": 0.25, "Sum": 0.1, "Fal": 1.0},
		"Festive": {"Win": 1.0, "Spr": 0.1, "Sum": 0.1, "Fal": 0.25}
}

var report_td = {
	"sales" : 0.0,
	"tips" : 0.0,
	"cost" : 0.0,
	"permits" : 0.0,
	"wasted" : 0.0,
	"marketing" : 0.0,
	"netprofit" : 0.0
}

var report_tw = {
	"sales" : 0.0,
	"tips" : 0.0,
	"cost" : 0.0,
	"permits" : 0.0,
	"wasted" : 0.0,
	"marketing" : 0.0,
	"netprofit" : 0.0
}

var report_lw = {
	"sales" : 0.0,
	"tips" : 0.0,
	"cost" : 0.0,
	"permits" : 0.0,
	"wasted" : 0.0,
	"marketing" : 0.0,
	"netprofit" : 0.0
}


func _ready():
	#Initialize all the coffee types here
#region CoffeeTypes Data
	coffee_types["Espresso"] = CoffeeType.new("Espresso", [2.00, 2.25, 2.50, 2.75], 0, {"Coffee": 1, "Water": 1}, ["Espresso Machine"], true, 0, "Classic", 0, 0)
	coffee_types["Americano"] = CoffeeType.new("Americano", [2.25, 2.50, 2.75, 3.00], 0, {"Coffee": 1, "Water": 3}, ["Espresso Machine"], true, 2, "Classic", 0, 0)
	coffee_types["Cappuccino"] = CoffeeType.new("Cappuccino", [2.50, 2.75, 3.00, 3.5], 0, {"Coffee": 1,"Milk": 2, "Cream": 1}, ["Espresso Machine", "Milk Frother"], false, 1, "Classic", 0, 0)
	coffee_types["Hot Chocolate"] = CoffeeType.new("Hot Chocolate", [3.00, 3.50, 4.00, 4.50], 0, {"Milk": 2, "Chocolate": 2}, ["Espresso Machine", "Milk Frother"], false, 7, "Festive", 0, 0)
	coffee_types["Freddo"] = CoffeeType.new("Freddo", [3.00, 3.50, 4.00, 4.50], 0, {"Coffee": 1, "Milk": 2, "Ice": 2}, ["Espresso Machine", "Ice Machine"], false, 8, "Cold Brew", 0, 0)
	coffee_types["Frappe"] = CoffeeType.new("Frappe", [3.50, 4.00, 4.50, 5.00], 0, {"Coffee": 1, "Milk": 1, "Ice Cream": 1, "Ice": 2, "Syrup": 1}, ["Espresso Machine"], false, 10, "Cold Brew", 0, 0)
	coffee_types["Vanilla Latte"] = CoffeeType.new("Vanilla Latte", [3.50, 4.00, 4.50, 5.00], 0, {"Coffee": 1, "Milk": 2, "Syrup": 1}, ["Espresso Machine", "Milk Frother"], false, 6, "Fruity", 0, 0)
	coffee_types["Irish Coffee"] = CoffeeType.new("Irish Coffee", [4.00, 4.75, 5.50, 6.50], 0, {"Coffee": 1, "Milk": 1, "Cream": 1, "Chocolate": 1, "Liquor": 1}, ["Espresso Machine", "Milk Frother", "Liquor License"], false, 11, "Festive", 0, 0)

#endregion

	#Initialize all the stock items here ["Name"], [Cost], [QntyIncrease], [Quality], [Stock], [boolUnlocked], [CostPerUnit], [iconID]
#region StockItems Data
	stock_items["Coffee"] = StockItem.new("Coffee", 7.50, 5, 0, 15, true, 0.75, 0)
	stock_items["Water"] = StockItem.new("Water", 1.00, 5, 0, 10, true, 0.10, 3)
	stock_items["Milk"] = StockItem.new("Milk", 2.50, 5, 0, 5, false, 0.25, 2)
	stock_items["Cream"] = StockItem.new("Cream", 3.00, 5, 0, 5, false, 0.30, 4)
	stock_items["Chocolate"] = StockItem.new("Chocolate", 5.00, 5, 0, 5, false, 0.50, 5)
	stock_items["Ice Cream"] = StockItem.new("Ice Cream", 7.50, 5, 0, 5, false, 0.75, 7)
	stock_items["Ice"] = StockItem.new("Ice", 1.50, 5, 0, 5, false, 0.15, 6)
	stock_items["Syrup"] = StockItem.new("Syrup", 5.00, 5, 0, 5, false, 0.50, 9)
	stock_items["Liquor"] = StockItem.new("Liquor", 12.50, 5, 0, 5, false, 1.25, 11)
	stock_items["Cups"] = StockItem.new("Cups", 2.00, 5, 0, 15, true, 0.20, 1)

#endregion

	# Initialize upgrades here using a dictionary with the upgrade's name as the key
#region Stand Data
	stand["Basic Cart"] = Upgrade.new("Basic Cart", "Basic small cart for starters", "Upgrades_Limit", "Upgrades limit: ", 3, true, 0, 7)
	stand["Bigger Cart"] = Upgrade.new("Bigger Cart", "Bigger cart space for more upgrades", "Upgrades_Limit", "Upgrades limit: ",6, false, 350, 7)
	stand["Café Hut"] = Upgrade.new("Café Hut", "A spacious hut that offers more storage", "Upgrades_Limit", "Upgrades limit: ", 10, false, 600, 2)

#endregion

	# Initialize upgrades here using a dictionary with the upgrade's name as the key
#region Upgrades Data
	upgrades["Ice Maker"] = Upgrade.new("Ice Maker", "Creates ice everyday", "Create_Ice", "Ice per day: +",25, false, 100, 3)
	upgrades["Water Filter"] = Upgrade.new("Water Filter", "Filter the tap water and save cost", "Create_Water", "Water per day: +", 25, false, 100, 2)
	upgrades["Refrigerator"] = Upgrade.new("Refrigerator", "Prevents milk and cream from expiring", "Refrigerate", "Refridgeration", 1, false, 200, 3)
	upgrades["Sign Board"] = Upgrade.new("Sign Board", "Improves your visibility attracting more people", "Attraction", "Increase attraction", 0.05, false, 50, 3)
	upgrades["Decorative Lights"] = Upgrade.new("Decorative Lights", "Decoration that attracts more people", "Attraction", "Increase attraction", 0.10, false, 80, 3)
	upgrades["Cash Register"] = Upgrade.new("Cash Register", "Helps with handling the payments faster", "Service_Speed", "Service speed", 1, false, 150, 3)
	upgrades["Specials Board"] = Upgrade.new("Specials Board", "Allows listing special coffees", "Specials_Board", "Unlock specials board", 1, false, 75, 3)
	upgrades["Umbrella"] = Upgrade.new("Umbrella", "Provides rain protection to your customers", "Rain_Queue_Size", "Negates weather impact", 1, false, 125, 3)
	upgrades["Music System"] = Upgrade.new("Music System", "Music to relax your customers who are waiting", "Queue_Size", "Customer patience",1, false, 150, 3)
	upgrades["Storage Box"] = Upgrade.new("Storage Box", "Increases stock storage size", "Stock_Limit", "Stock storage limit: +",25, false, 175, 3)
	upgrades["Storage Shelf"] = Upgrade.new("Storage Shelf", "Increases stock storage size", "Stock_Limit", "Stock storage limit: +", 50, false, 300, 3)
	upgrades["Seatings"] = Upgrade.new("Seatings", "Allows customers to sit and relax (tips)", "Seatings", "Seatings", 1, false, 400, 3)

#endregion

#region Equipment Data
	grinders["None"] = Equipment.new("None", "Just use instant coffee", 0, 0, 0, 0)
	grinders["Basic Coffee Grinder"] = Equipment.new("Basic Coffee Grinder", "A basic grinder that keeps freshness by grinding your own coffee", 1, 0, 150, 1)
	grinders["Advanced Coffee Grinder"] = Equipment.new("Advanced Coffee Grinder", "An advanced grinder that improves quality and is faster",  2, 0, 350, 2)
	
	espresso_machines["None"] = Equipment.new("None", "Just use a boiler and basic frother", 0, 0, 0, 0)
	espresso_machines["Basic Espresso Machine"] = Equipment.new("Basic Espresso Machine", "Prepare coffee faster", 0, 1, 200, 1)
	espresso_machines["Advanced Espresso Machine"] = Equipment.new("Advanced Espresso Machine", "A top of the line machine that keeps consistency",  0, 2, 450, 2)

#endregion

#region Advertising Data
	advertisements["Leaflets"] = Advertisement.new("Leaflets", "Distribute leaflets in the neighbourhood", 5.00, 50, 0, 0)
	advertisements["Local newspaper"] = Advertisement.new("Local newspaper", "Advertise in your local newspaper", 10.00, 75, 1, 0)
	advertisements["Social media ads"] = Advertisement.new("Social media ads", "Buy ad campaign for popular social media platforms", 15.00, 125, 2, 0)
	advertisements["Billboards"] = Advertisement.new("Billboards", "Advertise on billboards across major public transport", 20.00, 200, 3, 0)

#endregion

#region Skills Data
	skills["Barista"] = { "Name": "Barista", "Level": 0}
	skills["Marketing"] = { "Name": "Marketing", "Level": 0}
	skills["Service"] = { "Name": "Service", "Level": 0}

#endregion

func purchase_ingredient(ingredient: String, quantity: int) -> bool:
	var total_cost = stock_items[ingredient].cost * quantity / stock_items[ingredient].pack_quantity
	if money >= total_cost: #Need to implement stock limit condition in future
		money -= total_cost
		stock_items[ingredient].stock += quantity
		return true
	return false

func format_cash(amount: float) -> String:
	# Convert to string with two decimal places
	var formatted = "%.2f" % amount
	var parts = formatted.split(".")
	var integer_part = parts[0]
	var decimal_part = parts[1]

	# Check for negative sign
	var is_negative = integer_part.begins_with("-")
	if is_negative:
		integer_part = integer_part.substr(1, integer_part.length() - 1)

	# Add commas
	var with_commas = ""
	var count = 0
	for i in range(integer_part.length() - 1, -1, -1):
		count += 1
		with_commas = integer_part[i] + with_commas
		if count % 3 == 0 and i != 0:
			with_commas = "," + with_commas

	# Add the negative sign back if necessary
	if is_negative:
		#with_commas = "-" + with_commas
		return "-$" + with_commas + "." + decimal_part
	
	else :
		return "$" + with_commas + "." + decimal_part


#func format_cash(amount: float) -> String:
	## Convert to string with two decimal places
	#var formatted = "%.2f" % amount
	#var parts = formatted.split(".")
	#var integer_part = parts[0]
	#var decimal_part = parts[1]
#
	## Add commas
	#var with_commas = ""
	#var count = 0
	#for i in range(integer_part.length() - 1, -1, -1):
		#count += 1
		#with_commas = integer_part[i] + with_commas
		#if count % 3 == 0 and i != 0:
			#with_commas = "," + with_commas
#
	#return "$" + with_commas + "." + decimal_part

func create_ice() :
	if upgrades_owned.has("Ice Maker") && stock_items["Ice"].stock < 25:
		stock_items["Ice"].stock += upgrades_owned["Ice Maker"].bonus
		if stock_items["Ice"].stock > max_stock_capacity :
			stock_items["Ice"].stock = max_stock_capacity

func create_water() :
	if upgrades_owned.has("Water Filter") :
		stock_items["Water"].stock += upgrades_owned["Water Filter"].bonus
		if stock_items["Water"].stock > max_stock_capacity :
			stock_items["Water"].stock = max_stock_capacity

func has_refridgerator() :
	
	var exp_items = ["Milk", "Cream", "Ice Cream", "Ice"]
	
	if upgrades_owned.has("Refrigerator") == false :
		for i in exp_items : 
			report_td["wasted"] -= (float(stock_items[i].stock) / float(stock_items[i].pack_quantity) * float(stock_items[i].cost))
			stock_items[i].stock = 0

func increase_attraction(upgrade) :
	if upgrades_owned[upgrade].bonus_type == "Attraction" :
		attraction += upgrades_owned[upgrade].bonus

func increase_queue_size(upgrade) :
	if upgrades_owned[upgrade].bonus_type == "Queue_Size":
		queue_limit += upgrades_owned[upgrade].bonus
		rain_queue_limit += upgrades_owned[upgrade].bonus

func rain_protection(upgrade) :
	if upgrades_owned[upgrade].bonus_type == "Rain_Queue_Size":
		rain_queue_limit += upgrades_owned[upgrade].bonus

func faster_service(upgrade) :
	if upgrades_owned[upgrade].bonus_type == "Service_Speed":
		serving_time -= upgrades_owned[upgrade].bonus

func increase_stock_capacity(upgrade):
	if upgrades_owned[upgrade].bonus_type == "Stock_Limit":
		max_stock_capacity += upgrades_owned[upgrade].bonus

func specials_board_purchased(upgrade):
	if upgrades_owned[upgrade].bonus_type == "Specials_Board":
		specials_board = true

func calculate_coffee_quality(coffee_level) -> float:
	var level = coffee_level * 10
	var grinder = grinder_level * 10
	var skill = skills["Barista"]["Level"] * 4
	var total
	total = base_quality + level + grinder + skill
	return clamp(total, 20, 90)

func wants_coffee() -> float:
	var total
	total = base_demand + popularity + attraction + ad_boost
	return clamp(total, 20, 75)

func get_customer_coffee_choice(current_season: String, specials_board: Array) -> String:
	var total_demand = 0.0
	var coffee_weights = []
	
	# Calculate the demand weights based on the season and specials board
	for coffee in coffee_types:
		var base_demand = demand_adjustments[coffee_types[coffee].category][current_season]
		if coffee_types[coffee].name in specials_board:
			base_demand *= 1.5  # Increase demand by 50% if on specials board
		coffee_weights.append({"name": coffee_types[coffee].name, "weight": base_demand})
		total_demand += base_demand

	# Normalize weights to make them a probability distribution
	var random_value = randi() % int(total_demand * 100)
	var cumulative_weight = 0.0

	# Pick a coffee based on the weighted random choice
	for coffee in coffee_weights:
		cumulative_weight += coffee["weight"] * 100
		if random_value < cumulative_weight:
			return coffee["name"]

	return "No Coffee"  # Fallback if no coffee is selected (shouldn't happen)

func ad_boost_calculator():
	ad_boost = 0
	for ad in advertisements :
		if advertisements[ad].days_left > 0 :
			ad_boost += advertisements[ad].bonus


