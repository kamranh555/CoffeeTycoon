extends Node2D

var lifetime = 3.0  # Duration for the icon to stay visible

func _ready():
	# Start a timer to remove the icon after 'lifetime' seconds
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)
	timer.start()

func _on_Timer_timeout():
	queue_free()  # Remove the icon
