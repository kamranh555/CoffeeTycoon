extends CanvasModulate

@export var gradient_texture:GradientTexture1D
@onready var cycle_time = Global.day_duration
var elapsed_time : float = 0.0
var cycle_active: bool = false

func _process(delta: float) -> void:
	if cycle_active:
		elapsed_time += delta # Update the elapsed time
		var normalized_time = elapsed_time / cycle_time # Calculate the normalized time (between 0 and 1) based on cycle_time

		# Go through gradient color forward and reverse (cycling twice)
		if normalized_time <= 0.5:
			# First half: move forward in the gradient
			var value = normalized_time * 2
			color = gradient_texture.gradient.sample(value)
		else:
			# Second half: reverse back through the gradient
			var value = 2 - normalized_time * 2
			color = gradient_texture.gradient.sample(value)
		
		# Reset elapsed_time when the cycle completes (after cycle_time seconds)
		if elapsed_time >= cycle_time:
			elapsed_time = 0.0  # Restart the cycle
			cycle_active = false
