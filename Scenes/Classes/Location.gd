class_name Location

var name: String
var info: String
var permit_cost: float
var unlocked: bool
var purchased: bool
var season_crowd: Dictionary
var week_crowd: Dictionary
var iconID: int

func _init(_name: String, _info: String, _permit_cost: float, _unlocked: bool, _purchased: bool, _season_crowd: Dictionary, _week_crowd: Dictionary, _iconID: int):
	name = _name
	info = _info
	permit_cost = _permit_cost
	unlocked = _unlocked
	purchased = _purchased
	season_crowd = _season_crowd
	week_crowd = _week_crowd
	iconID = _iconID
