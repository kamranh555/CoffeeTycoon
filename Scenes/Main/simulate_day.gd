extends PanelContainer

# Preload the people scene for instantiation
var people_scene = preload("res://Scenes/People/people.tscn")

# Variables defomed for the queue managing
var is_spawning = false
var people_list = []
var queue_limit = Global.queue_limit
var customer_coffee_desire : Array #Array to hold coffee desires of customers to be generated
var spawn_count = 0
@export var spawn_timer: Timer
@onready var queue = Global.people_queue
@export var spawner: Node2D
@onready var shoparea = get_node("Spawner/ShopArea")
@onready var cart_list = get_node("CoffeeCart").get_children(false)
@onready var cart_holder = get_node("CoffeeCart")
@onready var rain_drops = get_node("Rain")
@export var day_night_effect : CanvasModulate
@export var night_lights : Node2D

func _ready():
	Global.connect("update_stand_visual", Callable(self, "update_stand_visual"))
	Global.connect("update_upgrades_visual", Callable(self, "update_upgrades_visual"))
	Global.connect("update_equipment_visual", Callable(self, "update_equipment_visual"))

func _on_center_area_body_entered(body):
	if body.state == 0 && body.wants_coffee :
		body.state = 1

func _on_shop_area_body_entered(body):
	
	if body.state == 1 && body.wants_coffee :
	
		if queue.size() >= queue_limit :
			body.state = 3
			body.served = false
			body.show_icon(4)

		else :
			body.state = 2
			queue.append(body)
			var removal_time = randi_range(2,2)
			var timer = Timer.new()
			body.add_child(timer)
			timer.wait_time = removal_time
			timer.one_shot = true
			timer.connect("timeout", Callable(body, "_on_person_timer_timeout"))
			timer.start()

func _on_destroy_1_body_entered(body):
	people_list.erase(body)
	body.queue_free()

func _on_destroy_2_body_entered(body):
	people_list.erase(body)
	body.queue_free()
	
func _process(_delta):
	
	queue_limit = Global.queue_limit
	
	for people in people_list : 
		if !is_instance_valid(people):
			people_list.erase(people)
	
	if is_spawning == false :
		spawn_timer.stop()
		var all_served = all_people_served()
		
		if all_served == true :
			for people in people_list :
				if people != null :
					people.speed = 50
		

func _on_spawn_frequency_timeout():
	
	if spawn_count >= customer_coffee_desire.size() :
		return
	
	# Function called when the spawn frequency timer times out
	var new_person = people_scene.instantiate()
	new_person.wants_coffee = customer_coffee_desire[spawn_count]
	new_person.coffee_expectation = randf_range(0,100)
	var random = randi_range(1,2)
	new_person.spawn_point = random
	var spawn_point = ""
	new_person.y_path_position = Vector2(0,randi_range(-12,12))
	
	spawn_count += 1
	
	spawn_timer.wait_time = spawn_frequency()
	
	
	# to check if the path should be for customer or noncustomer
	if random == 1 :
		spawn_point = "Spawn1"
	else :
		spawn_point = "Spawn2"
	
	# Add the new person to a path in scene
	spawner.add_child(new_person)
	people_list.append(new_person)
	new_person.position = spawner.get_node(spawn_point).position + new_person.y_path_position
	
func all_people_served():
	for people in people_list :
		if people != null :
			if people.state <= 2 :
				return false
	return true

func spawn_frequency():
	
	var season = Global.locations[Global.location_name].season_crowd[Global.seasons[Global.date["season"]]]
	var weather = Global.weather_impact[Global.current_weather]
	var day_of_week = Global.locations[Global.location_name].week_crowd[weekday_weekend_check()]
	
	var wait_time = snapped((1 / (season + weather + day_of_week)), 0.01)
	return wait_time

func weekday_weekend_check():
	if Global.date["day_of_week"] <= 4:
		return "Weekday"
	if Global.date["day_of_week"] > 4:
		return "Weekend"

func update_stand_visual(index):
	for cart in cart_list : 
		cart.set_visible(false)
	
	var current_cart = cart_holder.get_child(index)
	current_cart.set_visible(true)

func update_upgrades_visual(index):
	for cart in cart_list : 
		var upgrade = cart.get_child(index)
		upgrade.set_visible(true)
	
func update_equipment_visual(index):
	for cart in cart_list : 
		var equipment_list = cart.get_child(1).get_children()
		for equipment in equipment_list :
			equipment.set_visible(false)
	
	for cart in cart_list : 
		var current_equipment = cart.get_child(1).get_child(index)
		current_equipment.set_visible(true)
		
func activate_rain() :
	if Global.current_weather == "Rain" :
		rain_drops.visible = true
	else : 
		rain_drops.visible = false
		
func day_night_cycle() :
	day_night_effect.cycle_active = true
	night_lights.cycle_active = true
