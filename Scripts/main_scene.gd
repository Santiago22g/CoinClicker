extends Control

var coins = 0
var amount_per_click = 1
var multiplier = 1
var is_frenzy_active = false
var drain_speed = 15.0 
var upgrades_data = []
var auto_coins_per_sec = 0

@onready var click_sound = $CoinSound
@onready var coin_meter = $TextureProgressBar 
@onready var total_label = $CoinTotal 
@onready var bg_panel = $Panel
@onready var main_background = $TextureRect

signal coins_changed
signal coin_clicked

func _ready() -> void:
	bg_panel.visible = false
	load_upgrades()
	
func _process(delta: float) -> void:
	if not is_frenzy_active and coin_meter.value > 0:
		coin_meter.value -= drain_speed * delta

func _on_texture_button_pressed() -> void:
	click_sound.play()
	var gain = amount_per_click * multiplier
	coins += gain
	
	if not is_frenzy_active:
		coin_meter.value += 5 
		if coin_meter.value >= coin_meter.max_value:
			activate_frenzy()
	
	total_label.text = str(coins) + " Coins"
	emit_signal("coins_changed", coins)
	emit_signal("coin_clicked", gain)

func activate_frenzy() -> void:
	is_frenzy_active = true
	multiplier = 2
	coin_meter.tint_progress = Color(2, 2, 2) 
	await get_tree().create_timer(10.0).timeout
	multiplier = 1
	is_frenzy_active = false
	coin_meter.value = 0
	coin_meter.tint_progress = Color(1, 1, 1)

func load_upgrades():
	var file = FileAccess.open("res://upgrades.json", FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	json.parse(json_string)
	upgrades_data = json.data["upgrades"]

func buy_upgrade(upgrade_id: String):
	for item in upgrades_data:
		if item["id"] == upgrade_id:
			var actual_price = int(item["base_cost"] * pow(1.15, item["level"]))
			if coins >= actual_price:
				coins -= actual_price
				item["level"] += 1
				if item["type"] == "click":
					amount_per_click += item["power"]
				else:
					auto_coins_per_sec += item["power"]
				
				_update_ui()
			else:
				print("¡No enough money!")

func _update_ui() -> void:
	total_label.text = str(coins) + " Coins"
	emit_signal("coins_changed", coins)

func _on_setting_button_pressed() -> void:
	bg_panel.visible = !bg_panel.visible

func _on_bg_1_pressed() -> void:
	main_background.texture = $Panel/HBoxContainer/BG1.texture_normal
	bg_panel.visible = false

func _on_bg_2_pressed() -> void:
	main_background.texture = $Panel/HBoxContainer/BG2.texture_normal
	bg_panel.visible = false

func _on_bg_3_pressed() -> void:
	main_background.texture = $Panel/HBoxContainer/BG3.texture_normal
	bg_panel.visible = false

func _on_bg_4_pressed() -> void:
	main_background.texture = $Panel/HBoxContainer/BG4.texture_normal
	bg_panel.visible = false


func _on_timer_timeout() -> void:
	coins += auto_coins_per_sec
	_update_ui()


func _on_button_upgrade_1_pressed(extra_arg_0: String) -> void:
	buy_upgrade(extra_arg_0)


func _on_button_upgrade_2_pressed(extra_arg_0: String) -> void:
	buy_upgrade(extra_arg_0)
