extends PanelContainer

@export var sales_td : Label
@export var sales_tw : Label
@export var sales_lw : Label
@export var tips_td : Label
@export var tips_tw : Label
@export var tips_lw : Label
@export var cost_td : Label
@export var cost_tw : Label
@export var cost_lw : Label
@export var permits_td : Label
@export var permits_tw : Label
@export var permits_lw : Label
@export var wasted_td : Label
@export var wasted_tw : Label
@export var wasted_lw : Label
@export var marketing_td : Label
@export var marketing_tw : Label
@export var marketing_lw : Label
@export var netprofit_td : Label
@export var netprofit_tw : Label
@export var netprofit_lw : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sales_td.text = Global.format_cash(Global.report_td["sales"])
	sales_tw.text = Global.format_cash(Global.report_tw["sales"])
	sales_lw.text = Global.format_cash(Global.report_lw["sales"])
	tips_td.text = Global.format_cash(Global.report_td["tips"])
	tips_tw.text = Global.format_cash(Global.report_tw["tips"])
	tips_lw.text = Global.format_cash(Global.report_lw["tips"])
	cost_td.text = Global.format_cash(Global.report_td["cost"])
	cost_tw.text = Global.format_cash(Global.report_tw["cost"])
	cost_lw.text = Global.format_cash(Global.report_lw["cost"])
	permits_td.text = Global.format_cash(Global.report_td["permits"])
	permits_tw.text = Global.format_cash(Global.report_tw["permits"])
	permits_lw.text = Global.format_cash(Global.report_lw["permits"])
	wasted_td.text = Global.format_cash(Global.report_td["wasted"])
	wasted_tw.text = Global.format_cash(Global.report_tw["wasted"])
	wasted_lw.text = Global.format_cash(Global.report_lw["wasted"])
	marketing_td.text = Global.format_cash(Global.report_td["marketing"])
	marketing_tw.text = Global.format_cash(Global.report_tw["marketing"])
	marketing_lw.text = Global.format_cash(Global.report_lw["marketing"])
	netprofit_td.text = Global.format_cash(Global.report_td["netprofit"])
	netprofit_tw.text = Global.format_cash(Global.report_tw["netprofit"])
	netprofit_lw.text = Global.format_cash(Global.report_lw["netprofit"])
	
	
	Global.report_td["netprofit"] = Global.report_td["sales"] + Global.report_td["tips"] + Global.report_td["cost"] + Global.report_td["permits"] + Global.report_td["wasted"] + Global.report_td["marketing"]
	Global.report_tw["netprofit"] = Global.report_tw["sales"] + Global.report_tw["tips"] + Global.report_tw["cost"] + Global.report_tw["permits"] + Global.report_tw["wasted"] + Global.report_tw["marketing"]
