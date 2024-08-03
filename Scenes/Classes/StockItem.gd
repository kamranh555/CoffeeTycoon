class_name StockItem

var name: String
var cost: float
var pack_quantity: int
var quality: int
var stock: int
var unlocked: bool
var cost_per_unit: float
var iconID: int

func _init(_name: String, _cost: float, _pack_quantity: int, _quality: int, _stock: int, _unlocked: bool, _cost_per_unit: float, _icon_ID: int):
	name = _name
	cost = _cost
	pack_quantity = _pack_quantity
	quality = _quality
	stock = _stock
	unlocked = _unlocked
	cost_per_unit = _cost_per_unit
	iconID = _icon_ID
