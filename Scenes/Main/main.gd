extends Control

@export var scene_view : Control

@export var spawn_duration = 10  # Duration for spawning people
var is_spawning = false  # Flag to control the spawning process

@onready var day_timer = $DayTimer
@export var money_label: Label
@export var sale_info_label: Label
@export var points_label: Label
@export var start_button: Button # Reference to the Start Button
@export var popularity_bar: ProgressBar #Reference to popularity bar
@export var experience_bar: ProgressBar #Reference to popularity bar
@export var timer_label: Label # Reference to the Timer Label
@export var tab_container: TabContainer
@export var date_label : Label # Reference to the Date Label

func _ready():
	
	money_label.text = "Money: " + Global.format_cash(Global.money)
	points_label.text = "KP: " + str(Global.points)
	popularity_bar.value = Global.popularity
	experience_bar.value = Global.experience
	update_weather()
	update_date_label()

func _process(_delta):
	money_label.text = "Money: " + Global.format_cash(Global.money)
	points_label.text = "KP: " + str(Global.points)
	popularity_bar.value = Global.popularity
	experience_bar.value = Global.experience
	
	#update_stock_label() # Update the stock information on main screen
		# Process logic for managing spawning and UI updates
	if is_spawning:
		start_button.disabled = true
		Global.ad_boost_calculator()
		
		var i = 0
		while i < 7 :
			tab_container.set_tab_disabled(i,true)
			i += 1

		# Check if the spawning duration has ended
	if day_timer.time_left <= 0 :
		is_spawning = false  # Stop spawning
		scene_view.is_spawning = false
		
		if scene_view.people_list.size() <= 0 && start_button.disabled == true :
			start_button.disabled = false # Enable the start button
			end_day()
			
			for ad in Global.advertisements :
				if Global.advertisements[ad].days_left > 0 :
					Global.advertisements[ad].days_left -= 1

		# Update the timer label
	timer_label.text = "Time Left: %s" % str(int(day_timer.time_left))

func _on_start_button_pressed():
	
	if start_button.text == "Next Day" :
		var i = 0
		while i < 7 :
			tab_container.set_tab_disabled(i,false)
			i += 1
		tab_container.current_tab = 0
		#Daily report update
		for item in Global.report_td.keys():
			Global.report_td[item] = 0
		
		next_day()
	
	elif start_button.text ==  "Main" :
		if tab_container.current_tab != 0 : 
			tab_container.current_tab = 0
		
	else : 
		# Function called when the start button is pressed
		day_timer.wait_time = spawn_duration
		day_timer.start()
		is_spawning = true
		scene_view.is_spawning = true
		scene_view.spawn_timer.start()
	
		Global.create_ice()
		Global.create_water()
	


func next_day():
	# Increment the day
	Global.date["day"] += 1
	Global.date["day_of_week"] += 1
	
	# Check if the day exceeds the length of the season
	if Global.date["day"] > 7:
		Global.date["day"] = 1
		Global.date["season"] += 1
		
		# Check if the season exceeds the number of seasons
		if Global.date["season"] > 3:
			Global.date["season"] = 0
			Global.date["year"] += 1
	
	# Check if the day_of_week exceeds the number of days in the week
	if Global.date["day_of_week"] > 6:
		Global.date["day_of_week"] = 0
		for item in Global.report_lw.keys():
			Global.report_lw[item] = 0
		update_weekly_profit()
		for item in Global.report_tw.keys():
			Global.report_tw[item] = 0
	
	# Update the weather
	update_weather()
	# Update the date label
	update_date_label()
	
	
func update_date_label():
	var season_name = Global.seasons[Global.date["season"]]
	var day_name = Global.days_of_week[Global.date["day_of_week"]]
	var date_text = "Y %d, %s, %s (%s)" % [Global.date["year"], season_name, day_name, Global.current_weather]
	date_label.text = date_text
	
	
# Function to update the weather based on the season
func update_weather():
	var season_name = Global.seasons[Global.date["season"]]
	var weather_chances = Global.weather_probabilities[season_name]
	
	# Generate a random number between 0 and 1
	var random_value = randf()
	
	if random_value < weather_chances["snow"]:
		Global.current_weather = "Snowy"
	elif random_value < weather_chances["snow"] + weather_chances["rain"]:
		Global.current_weather = "Rainy"
	else:
		Global.current_weather = "Clear"

func update_daily_profit():
	#Daily report update
	for i in Global.report_td.keys():
		Global.report_tw[i] += Global.report_td[i]
		
func update_weekly_profit():
	#Daily report update
	for i in Global.report_td.keys():
		Global.report_lw[i] += Global.report_tw[i]
		
func end_day ():
	tab_container.current_tab = 1
	start_button.text = "Next Day"
	Global.has_refridgerator()
	update_daily_profit()

func _on_tab_container_tab_changed(tab):
	if tab_container.current_tab != 0 : 
		start_button.text = "Main"
	else : 
		start_button.text = "Start Day"
