extends PanelContainer

var skill_name = "Barista"
@export var label : Label
@export var bar : ProgressBar
@export var button : Button

# Called when the node enters the scene tree for the first time.
func _ready():
	update_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_ui():
	label.text = skill_name + ": " + str(Global.skills[skill_name]["Level"]) + "/5"
	bar.value = Global.skills[skill_name]["Level"]
	

func _on_upgrade_button_pressed():
	if Global.points >= 1:
		Global.points -= 1
		Global.skills[skill_name]["Level"] += 1
		update_ui()
		
		if Global.skills[skill_name]["Level"] == 5 :
			button.text = "Upgraded"
			button.disabled = true
	
