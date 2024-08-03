extends PanelContainer

@export var likes_label : Label
@export var followers_label : Label
@export var total_posts : Label
@export var post_button : Button
@export var image_icon : Sprite2D

func _ready():
# Update UI with the first item
	image_icon.frame = randi_range(0,7)
	update_ui()

func update_ui():
	likes_label.text = "Likes on post: " + str(Global.current_post_likes)
	followers_label.text = "Total followers: " + str(Global.social_media_followers)
	total_posts.text = "Total posts: " + str(Global.total_posts)
	post_button.text = "Create a post"

func calculate_followers() -> int :
	var skill = Global.skills["Marketing"]["Level"]
	var min = randi_range(50,200)
	var add = randi_range(50,200) * skill
	var new_followers = skill + min + add
	return new_followers

func popularity_boost() -> float :
	var skill = Global.skills["Marketing"]["Level"]
	var min = randi_range(0.25,1.00)
	var add = randi_range(0.25,0.50) * skill
	var pop_boost = min + add
	return pop_boost
	
func likes() -> int :
	var skill = Global.skills["Marketing"]["Level"]
	var min = randi_range(100,300)
	var add = randi_range(100,300) * skill
	var pop_boost = min + add
	return pop_boost

func _on_upgrade_button_pressed():
	if Global.points >= 1:
		Global.points -= 1
		Global.social_media_followers += calculate_followers()
		Global.popularity += popularity_boost()
		Global.total_posts += 1
		Global.current_post_likes = likes()
		image_icon.frame = randi_range(0,7)
		update_ui()
