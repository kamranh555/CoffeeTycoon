extends CharacterBody2D

@export var speed = randi_range(20,25) # Randomly set speed for each person
@onready var animation = $AnimatedSprite2D # Reference to the animated sprite
@onready var spawner = get_parent()  # Reference to the spawner
@onready var queue = Global.people_queue # Reference to the global queue
@onready var serve_position = spawner.find_child("ShopArea",true).position # Serve position in the shop
@onready var coffee_list = Global.coffee_types.keys()
@onready var sale_info_label = get_node("/root/Main/MainVBox/OtherInfo/VBoxContainer/SaleInfoLabel")

@onready var total_serve_time = Global.serving_time + Global.coffee_speed
signal start_serve_timers
var purchase_start = false

var queue_gap = 16
var previous_position = Vector2() # Tracks the previous position for animation
var queue_position = Vector2() # Position in the queue

var serving_time = 0 # Time spent at serving
var coffee_choice = "Espresso"
var coffee_expectation : float
var spawn_point = 0
var y_path_position = Vector2()
var state = 0

var people_id = randi_range(1,15)  # ID for differentiating people
var wants_coffee = false # Flag to determine if the person wants coffee
var served = false # Flag to check if served

var icon_scene = preload("res://Scenes/People/feedback_icon.tscn")

func _ready():
	previous_position = global_position #Initialize starting position
	
	if wants_coffee == false :
		state = 4
	
	#choosing a coffee
	coffee_choice = Global.get_customer_coffee_choice(Global.seasons[Global.date["season"]], Global.specials_list)

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


func _physics_process(delta):
	# Physics process for updating character movement
	updateAnimation()
	update_queue_positions()
	var direction = queue_position - position
	
	#State 0: when customer is spawned it moves towards the other end of screen
	if spawn_point == 1 && state == 0 :
		position = position.move_toward(Vector2(spawner.find_child("Destroy2").position.x,position.y),delta*speed)
		
	elif spawn_point == 2 && state == 0 :
		position = position.move_toward(Vector2(spawner.find_child("Destroy1").position.x,position.y),delta*speed)
	
	#State 1: If customer wants coffee it moves towards the shop
	elif state == 1 :
		position = position.move_toward(serve_position,delta*speed)
	
	#State 2: Person has moved towards the shop and now enters the queue
	elif state == 2 && served == false:
		
		#Function to check their queue position na dmove accordingly
		move_towards_queue_position(delta)
		
		#To face them left if their position is not in the purchase area
		if direction.length() <= 2 && position.distance_to(serve_position) >= 1:
			animation.play("people"+str(people_id)+"_idle_left")
		
		#To face them up towards the shop once they are being served
		if queue.size() > 0 && queue[0].position.distance_to(serve_position) < 1 && queue[0] == self:
			var person = queue[0]
			person.serving_time += delta
			animation.play("people"+str(people_id)+"_idle_up")
			
			#Check if their coffee type is available (need to update code if false)
			if person.coffee_choice in Global.coffee_types:
			# Flag to check if all ingredients are available
				var can_serve = true
				
				# Check if cups are available
				if Global.stock_items["Cups"].stock <= 0:
					sale_info_label.text = "Not enough cups"
					can_serve = false
				
				#If their coffee type is available, following code checks the recipe against stock to see if stock is sufficient
				if can_serve :
					 # Check if recipe ingredients are sufficient
					for ingredient in Global.coffee_types[person.coffee_choice].recipe:
						if Global.stock_items[ingredient].stock < Global.coffee_types[person.coffee_choice].recipe[ingredient]:
							sale_info_label.text = "Not enough ingredients for " + person.coffee_choice
							can_serve = false
							person.purchase_start = true
							break
							
							
					if not person.purchase_start:
							person.purchase_start = true
							start_serve_timers.emit()
							
				#If ingredients are sufficient, the order is processed below
				if can_serve && person.serving_time >= total_serve_time :
				# Deduct one cup for the sale
					Global.stock_items["Cups"].stock -= 1
					Global.report_td["cost"] -= (float(1) / float(Global.stock_items["Cups"].pack_quantity) * float(Global.stock_items["Cups"].cost))
				
				# Deduct the stock items from the stock items used
					for ingredient in Global.coffee_types[person.coffee_choice].recipe:
						Global.stock_items[ingredient].stock -= Global.coffee_types[person.coffee_choice].recipe[ingredient]
						Global.report_td["cost"] -= (float(Global.coffee_types[person.coffee_choice].recipe[ingredient]) * float(Global.stock_items[ingredient].cost) / float(Global.stock_items[ingredient].pack_quantity))
					Global.money += Global.coffee_types[person.coffee_choice].price[Global.coffee_types[person.coffee_choice].level]
					Global.report_td["sales"] += Global.coffee_types[person.coffee_choice].price[Global.coffee_types[person.coffee_choice].level]
					sale_info_label.text = ("Sold one " + person.coffee_choice)
					Global.coffee_types[person.coffee_choice].daily_count += 1
					person.served = true
					person.state = 3
					
					#Check whether person liked the coffee
					if coffee_expectation <= Global.calculate_coffee_quality(Global.coffee_types[person.coffee_choice].level) :
						person.show_icon(2)
						Global.popularity += 0.1
						experience_calculate(0.05)
						
					elif coffee_expectation <= Global.calculate_coffee_quality(Global.coffee_types[person.coffee_choice].level) * 2/3 :
						person.show_icon(5)
						Global.popularity += 0.0
						experience_calculate(0.05)
						
					else :
						person.show_icon(3)
						if Global.popularity >= 0 :
							Global.popularity -= 0.05
						experience_calculate(0.05)
					
					#remove person from the queue
					queue.erase(person)

				# Update person status
				if can_serve == false :
					person.served = false
					person.state = 3
					person.show_icon(7)
					queue.erase(person)
		
	elif state == 3 :
		var go_center = Vector2(position.x,(spawner.find_child("Center").position.y + y_path_position.y))
		position = position.move_toward(go_center, delta*speed)
		if position.distance_to(go_center) < 1 :
			state = 4
			
	elif state == 4 :
			if spawn_point == 1:
				position = position.move_toward(Vector2(spawner.find_child("Destroy2").position.x,position.y),delta*speed)
			elif spawn_point == 2:
				position = position.move_toward(Vector2(spawner.find_child("Destroy1").position.x,position.y),delta*speed)
	

func update_queue_positions():
	# Update the position of each person in the queue
	var shoparea_position = spawner.find_child("ShopArea").position  # Adjust as per your scene structure
	for i in range(queue.size()):
		var target_position = shoparea_position + Vector2(i * queue_gap, 0)
		queue[i].queue_position = target_position

func move_towards_queue_position(delta):
	# Function to move the character towards their queue position
	var direction = queue_position - position
	if direction.length() > 1:
		position += direction.normalized() * speed * delta  # Adjust speed as needed
	
	
func show_icon(frame):
	var icon = icon_scene.instantiate()
	add_child(icon)
	icon.get_child(0).frame = frame
	# Position the icon above the character
	icon.position = Vector2(8, -12)  # Adjust the Y offset as needed
	
func experience_calculate(exp) :
	if Global.experience + exp >= 1 :
		Global.points += 1
		Global.experience = 0
	else :
		Global.experience += exp
