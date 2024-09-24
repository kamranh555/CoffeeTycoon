extends Node2D

@onready var cycle_time = Global.day_duration
var elapsed_time : float = 0.0
var lights_on: bool = true
var cycle_active: bool = false

func _process(delta: float) -> void:
	if cycle_active:
		elapsed_time += delta # Update the elapsed time
		var normalized_time = elapsed_time / cycle_time # Calculate the normalized time (between 0 and 1) based on cycle_time

		if normalized_time <= 0.05 or normalized_time >= 0.95:
			for child in get_children():
				child.visible = true
		else:
			for child in get_children():
				child.visible = false
		
		# Reset elapsed_time when the cycle completes (after cycle_time seconds)
		if elapsed_time >= cycle_time:
			elapsed_time = 0.0  # Restart the cycle
			cycle_active = false
			for child in get_children():
				child.visible = true
