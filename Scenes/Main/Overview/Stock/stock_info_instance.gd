extends BoxContainer

@export var stock_image : Sprite2D
@export var stock_text : Label

var stock_name = ""

func _process(_delta):
	stock_image.frame = Global.stock_items[stock_name].iconID
	stock_text.text = str(Global.stock_items[stock_name].stock)
