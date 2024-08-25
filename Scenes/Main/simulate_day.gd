extends PanelContainer

# Preload the people scene for instantiation
var people_scene = preload("res://Scenes/People/people.tscn")
var serving_progress_bar = preload("res://Scenes/Main/serving_progress_bar.tscn")

# Variables defomed for the queue managing
var is_spawning = false
var people_list = []
var queue_limit = Global.queue_limit
@export var spawn_timer: Timer
@onready var queue = Global.people_queue
@export var spawner: Node2D
@onready var shoparea = get_node("Spawner/ShopArea")

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

func _ready():
	pass
	
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
	# Function called when the spawn frequency timer times out
	var new_person = people_scene.instantiate()
	new_person.wants_coffee = randf_range(0,100) <= Global.wants_coffee()
	new_person.coffee_expectation = randf_range(0,100)
	new_person.start_serve_timers.connect(Callable(self, "on_start_serve_timers"))
	var random = randi_range(1,2)
	new_person.spawn_point = random
	var spawn_point = ""
	new_person.y_path_position = Vector2(0,randi_range(-12,12))
	
	
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
	
func on_start_serve_timers():

	var progress_bar = serving_progress_bar.instantiate()
	progress_bar.run_time = Global.coffee_speed
	progress_bar.index = 0
	progress_bar.coffee_serve = true
	shoparea.add_child(progress_bar)
	progress_bar.position = Vector2(-15,-60)
	progress_bar.coffee_prepared.connect(Callable(self, "on_coffee_prepared"))
	
func on_coffee_prepared():
	var progress_bar = serving_progress_bar.instantiate()
	progress_bar.run_time = Global.serving_time
	progress_bar.index = 1
	progress_bar.coffee_serve = false
	shoparea.add_child(progress_bar)
	progress_bar.position = Vector2(-15,-60)
