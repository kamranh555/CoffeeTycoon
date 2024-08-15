extends BoxContainer

@export var coffee_image : Sprite2D
@export var coffee_text : Label

var coffee_name = ""

func _process(_delta):
	coffee_image.frame = Global.coffee_types[coffee_name].iconID
	coffee_text.text = str(Global.coffee_types[coffee_name].daily_count)
