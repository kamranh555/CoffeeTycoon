extends CharacterBody2D

# Define the states using an enum
enum PersonState {
	MOVING_TO_CENTER,
	MOVING_TO_SHOP,
	IN_QUEUE,
	BEING_SERVED,
	EXITING_CENTER,
	EXITING_SCENE
}

# State variable using the enum
var state : PersonState = PersonState.MOVING_TO_CENTER

@onready var speed = randi_range(20,25) # Randomly set speed for each person
@onready var animation = $AnimatedSprite2D # Reference to the animated sprite
@onready var spawner = get_parent()  # Reference to the spawner
@onready var queue = Global.people_queue # Reference to the global queue
@onready var serve_position = spawner.find_child("ShopArea",true).position # Serve position in the shop
@onready var center_area_position = spawner.find_child("Center").position
@onready var sale_info_label = get_node("/root/Main/MainVBox/OtherInfo/VBoxContainer/SaleInfoLabel")
@onready var destroy1_position = spawner.find_child("Destroy1").position
@onready var destroy2_position = spawner.find_child("Destroy2").position

var serving_progress_bar = preload("res://Scenes/People/serving_progress_bar.tscn")
var icon_scene = preload("res://Scenes/People/feedback_icon.tscn")

var queue_gap = 16
var previous_position = Vector2() # Tracks the previous position for animation
var queue_position = Vector2() # Position in the queue
var y_path_position = Vector2()
var coffee_choice = "Espresso"
var coffee_expectation : float
var spawn_point = 0
var people_id = randi_range(1,15)  # ID for differentiating people
var wants_coffee = false # Flag to determine if the person wants coffee
var served = false # Flag to check if served (coffee or not)
var coffee_served = false #Flag to check if the coffee has been served to customer
var purchase_start = false


func _ready():
	previous_position = global_position #Initialize starting position
	
	if wants_coffee == false :
		state = PersonState.EXITING_SCENE
	
	#choosing a coffee
	coffee_choice = Global.get_customer_coffee_choice(Global.seasons[Global.date["season"]], Global.specials_list)
	
	Global.connect("coffee_served", Callable(self, "progress_bar_finished"))

func updateAnimation():
	# Update the character's animation based on movement
	var current_direction = global_position - previous_position
	var x = "_right"
	var y = "_walk"
	
	#direction = direction.normalized() # Normalize the direction vector to get the primary direction of movement
	current_direction = current_direction.normalized()
	
	# Determine the animation based on the direction vector
	if abs(current_direction.x) > abs(current_direction.y):
		if current_direction.x > 0:
			x = "_right"
			y = "_walk"
		else:
			x = "_left"
			y = "_walk"
	else :
		if current_direction.y > 0:
			x = "_down"
			y = "_walk"
		else:
			x = "_up"
			y = "_walk"
	
	previous_position = global_position
	
	animation.play("people"+str(people_id)+y+x)
	#print(current_direction)

# State machine using match statement
func _physics_process(delta):
	# Physics process for updating character movement
	updateAnimation()
	update_queue_positions()
	
	match state:
		PersonState.MOVING_TO_CENTER:
			move_to_center(delta)
		PersonState.MOVING_TO_SHOP:
			move_to_shop(delta)
		PersonState.IN_QUEUE:
			handle_in_queue(delta)
		PersonState.BEING_SERVED:
			handle_being_served(delta)
		PersonState.EXITING_CENTER:
			exit_center(delta)
		PersonState.EXITING_SCENE:
			exit_scene(delta)


#State methods
func move_to_center(delta):
	position = position.move_toward(center_area_position, delta * speed)
	if position.distance_to(center_area_position) < 1:
		state = PersonState.MOVING_TO_SHOP

func move_to_shop(delta):
	position = position.move_toward(serve_position, delta * speed)
	if position.distance_to(serve_position) < 1:
		state = PersonState.IN_QUEUE

func handle_in_queue(delta):
	move_towards_queue_position(delta)
	var direction = queue_position - position

	if direction.length() <= 2 and position.distance_to(serve_position) >= 1:
		animation.play("people" + str(people_id) + "_idle_left")

	if queue.size() > 0 and queue[0].position.distance_to(serve_position) < 1 and queue[0] == self:
		var person = queue[0]
		animation.play("people" + str(people_id) + "_idle_up")
		if person.coffee_choice in Global.coffee_types:
			start_service_if_possible(person)

func handle_being_served(delta):
	if coffee_served:
		served = true
		state = PersonState.EXITING_CENTER

func exit_center(delta):
	var go_center = Vector2(position.x, center_area_position.y + y_path_position.y)
	position = position.move_toward(go_center, delta * speed)
	if position.distance_to(go_center) < 1:
		state = PersonState.EXITING_SCENE

func exit_scene(delta):
	if spawn_point == 1:
		position = position.move_toward(destroy2_position, delta * speed)
	elif spawn_point == 2:
		position = position.move_toward(destroy1_position, delta * speed)

# Update queue positions
func update_queue_positions():
	var shoparea_position = spawner.find_child("ShopArea").position
	for i in range(queue.size()):
		var target_position = shoparea_position + Vector2(i * queue_gap, 0)
		queue[i].queue_position = target_position

# Move person towards queue position
func move_towards_queue_position(delta):
	var direction = queue_position - position
	if direction.length() > 1:
		position += direction.normalized() * speed * delta

# Show feedback icon
func show_icon(frame):
	var icon = icon_scene.instantiate()
	add_child(icon)
	icon.get_child(0).frame = frame
	icon.position = Vector2(8, -12)

# Progress bar for serving coffee
func progress_bar_finished():
	var person = queue[0]
	person.coffee_served = true

func start_serve_timers():
	var progress_bar = serving_progress_bar.instantiate()
	progress_bar.run_time = Global.coffee_speed
	progress_bar.index = 0
	progress_bar.coffee_serve = true
	spawner.find_child("ShopArea", true).add_child(progress_bar)
	progress_bar.position = Vector2(-15, -60)
	progress_bar.coffee_prepared.connect(Callable(self, "on_coffee_prepared"))

func on_coffee_prepared():
	var progress_bar = serving_progress_bar.instantiate()
	progress_bar.run_time = Global.serving_time
	progress_bar.index = 1
	progress_bar.coffee_serve = false
	spawner.find_child("ShopArea", true).add_child(progress_bar)
	progress_bar.position = Vector2(-15, -60)

# Helper functions for service logic
func start_service_if_possible(person):
	var can_serve = true
	
	# Check if cups are available
	if Global.stock_items["Cups"].stock <= 0:
		sale_info_label.text = "Not enough cups"
		can_serve = false

	# Check if ingredients are available
	for ingredient in Global.coffee_types[person.coffee_choice].recipe:
		if Global.stock_items[ingredient].stock < Global.coffee_types[person.coffee_choice].recipe[ingredient]:
			sale_info_label.text = "Not enough ingredients for " + person.coffee_choice
			can_serve = false
			person.purchase_start = true

	# If the person can start their purchase
	if person.purchase_start == false and can_serve == true:
		person.purchase_start = true
		start_serve_timers()

	# If the person cannot be served due to lack of stock
	if can_serve == false:
		# Show feedback that they were not served and remove them from the queue
		person.show_icon(7)  # Assuming 7 is an icon for failure
		person.served = false
		queue.erase(person)  # Remove from queue
		state = PersonState.EXITING_CENTER  # Move to exit
		return  # Early exit to avoid further processing
	
	 # If ingredients and cups are sufficient and the coffee is served
	if can_serve and person.coffee_served:
		# Update stock and sales
		Global.stock_items["Cups"].stock -= 1
		Global.report_td["cost"] -= (float(1) / float(Global.stock_items["Cups"].pack_quantity) * float(Global.stock_items["Cups"].cost))

		for ingredient in Global.coffee_types[person.coffee_choice].recipe:
			Global.stock_items[ingredient].stock -= Global.coffee_types[person.coffee_choice].recipe[ingredient]
			Global.report_td["cost"] -= (float(Global.coffee_types[person.coffee_choice].recipe[ingredient]) * float(Global.stock_items[ingredient].cost) / float(Global.stock_items[ingredient].pack_quantity))

		Global.money += Global.coffee_types[person.coffee_choice].price[Global.coffee_types[person.coffee_choice].level]
		Global.report_td["sales"] += Global.coffee_types[person.coffee_choice].price[Global.coffee_types[person.coffee_choice].level]
		sale_info_label.text = "Sold one " + person.coffee_choice
		Global.coffee_types[person.coffee_choice].daily_count += 1
		person.served = true
		queue.erase(person)
		state = PersonState.EXITING_CENTER

func experience_calculate(exp):
	if Global.experience + exp >= 1:
		Global.points += 1
		Global.experience = 0
	else:
		Global.experience += exp
