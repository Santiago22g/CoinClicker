extends Panel

@export var achievement_scene: PackedScene 
@export var popup_panel: Panel
@export var popup_label: Label
@onready var achievement_sound: AudioStreamPlayer2D = $AchievementSound

@onready var container = $ScrollContainer/VBoxContainer
var achievements_list = []

func _ready():
	load_data()
	render_achievements()
	if popup_panel:
		popup_panel.visible = false

func load_data():
	var file_path = "res://achievements.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	achievements_list = content["achievements"]

func render_achievements():
	for child in container.get_children():
		child.queue_free()
	
	for data in achievements_list:
		var instance = achievement_scene.instantiate()
		container.add_child(instance)
		instance.get_node("VBoxContainer/Title").text = data["title"]
		instance.get_node("VBoxContainer/Description").text = data["description"]
		
		if not data["unlocked"]:
			instance.modulate.a = 0.4 
		else:
			instance.modulate.a = 1.0 

func check_unlock(upgrade_id: String, current_level: int):
	var found_new_unlock = false
	
	for ach in achievements_list:
		if not ach["unlocked"] and ach["requirement"]["upgrade_id"] == upgrade_id:
			if current_level >= ach["requirement"]["value"]:
				ach["unlocked"] = true
				found_new_unlock = true
	
	if found_new_unlock:
		render_achievements()
		achievement_sound.play()
