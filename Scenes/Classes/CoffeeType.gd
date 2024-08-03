class_name CoffeeType

var name: String
var price: Array
var level: int
var recipe: Dictionary
var equipment_needed: Array
var unlocked: bool
var iconID: int
var category: String

func _init(_name: String, _price: Array, _level: int, _recipe: Dictionary, _equipment_needed: Array, _unlocked: bool, _icon_ID: int, _category: String):
	name = _name
	price = _price
	level = _level
	recipe = _recipe
	equipment_needed = _equipment_needed
	unlocked = _unlocked
	iconID = _icon_ID
	category = _category

