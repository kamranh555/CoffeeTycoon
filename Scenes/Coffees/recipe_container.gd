extends BoxContainer

var coffee_name = ""
var stock_name = ""

func _process(_delta):
	$BoxContainer.get_child(0).frame = Global.stock_items[stock_name].iconID
	$Label.text = str(Global.coffee_types[coffee_name].recipe[stock_name])
