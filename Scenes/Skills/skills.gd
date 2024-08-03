extends Control

@onready var skills_list = Global.skills.keys()
var skill_container = preload("res://Scenes/Skills/skill_container.tscn")
@export var child_container : VBoxContainer

func _ready():
	for skill in skills_list:
		var skill_instance = skill_container.instantiate()
		skill_instance.skill_name = skill
		child_container.add_child(skill_instance)
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
