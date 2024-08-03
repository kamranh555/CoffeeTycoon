class_name Upgrade

var name: String
var info: String
var bonus_type: String
var bonus_info: String
var bonus: float
var unlocked: bool
var cost: int
var iconID: int

func _init(_name: String, _info: String, _bonus_type: String, _bonus_info: String,_bonus: float, _unlocked: bool, _cost: int, _iconID):
	name = _name
	info = _info
	bonus_type = _bonus_type
	bonus_info = _bonus_info
	bonus = _bonus
	unlocked = _unlocked
	cost = _cost
	iconID = _iconID
