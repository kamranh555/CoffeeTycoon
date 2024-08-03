extends HBoxContainer

var run_time = 0
var index = 0
var coffee_serve = true
signal coffee_prepared
@onready var sprite = $Container/Sprite2D
@onready var progress_bar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.frame = index
	progress_bar.max_value = run_time
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_bar.value += delta
	
	if progress_bar.value >= run_time && coffee_serve == true :
		coffee_prepared.emit()
		self.queue_free()
		
	elif progress_bar.value >= run_time && coffee_serve == false:
		self.queue_free()
