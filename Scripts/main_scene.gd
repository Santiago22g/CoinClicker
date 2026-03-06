extends Control

var coins = 0
var amount_per_click = 1
var multiplier = 1
var is_frenzy_active = false
var drain_speed = 15.0 
var upgrades_data = []
var auto_coins_per_sec = 0.0

@onready var click_sound = $CoinSound
@onready var coin_meter = $TextureProgressBar 
@onready var total_label = $CoinTotal 
@onready var bg_panel = $Panel
@onready var main_background = $TextureRect
@onready var upgrade_list = $Panel2/ScrollContainer/VBoxContainer 
@onready var coins_per_second: Label = $CoinsPerSecond
@onready var desc_label: Label = $Panel2/DescriptionLabel

signal coins_changed
signal coin_clicked

func _ready() -> void:
	bg_panel.visible = false
	load_upgrades()
	_update_ui()

func _process(delta: float) -> void:
	if auto_coins_per_sec > 0:
		coins += auto_coins_per_sec * delta
		_update_ui()
		
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
	
	_update_ui()
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
	if file:
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			upgrades_data = json.data["upgrades"]
			vincular_botones_escena()

func vincular_botones_escena():
	var botones = upgrade_list.get_children()
	
	for i in range(upgrades_data.size()):
		if i < botones.size():
			var btn = botones[i] as Button
			var data = upgrades_data[i]
			
			btn.set_meta("upgrade_id", data["id"])
			
			if not btn.pressed.is_connected(_on_upgrade_pressed):
				btn.pressed.connect(_on_upgrade_pressed.bind(btn))
			
			if not btn.mouse_entered.is_connected(_on_mouse_entered_upgrade):
				btn.mouse_entered.connect(_on_mouse_entered_upgrade.bind(data))
			
			if not btn.mouse_exited.is_connected(_on_mouse_exited_upgrade):
				btn.mouse_exited.connect(_on_mouse_exited_upgrade)
			
			actualizar_texto_boton(btn, data)

func _on_upgrade_pressed(btn: Button):
	var id = btn.get_meta("upgrade_id")
	buy_upgrade(id, btn)

func buy_upgrade(upgrade_id: String, btn: Button):
	for item in upgrades_data:
		if item["id"] == upgrade_id:
			var actual_price = item["base_cost"] * pow(1.15, item["level"])
			if coins >= actual_price:
				coins -= actual_price
				item["level"] += 1
				btn.self_modulate = Color(0.5, 1.0, 0.5)
				if item["type"] == "click":
					amount_per_click += item["power"]
				else:
					auto_coins_per_sec += item["power"]
				
				actualizar_texto_boton(btn, item)
				_update_ui()
			else:
				print("No hay suficiente dinero")
			break

func actualizar_texto_boton(btn: Button, item: Dictionary):
	var price = item["base_cost"] * pow(1.15, item["level"])
	btn.text = "%s cc | %s | lvl %d" % [format_val(price), item["name"], item["level"]]

func _update_ui() -> void:
	total_label.text = format_val(coins) + " Coins"
	coins_per_second.text = str(auto_coins_per_sec) + " coins/s"
	emit_signal("coins_changed", coins)

func format_val(value: float) -> String:
	if value >= 1.0e15: return str(snapped(value / 1.0e15, 0.1)) + "Q"
	if value >= 1.0e12: return str(snapped(value / 1.0e12, 0.1)) + "T"
	if value >= 1.0e9: return str(snapped(value / 1.0e9, 0.1)) + "B"
	if value >= 1.0e6:  return str(snapped(value / 1.0e6, 0.1)) + "M"
	if value >= 1.0e3:  return str(snapped(value / 1.0e3, 0.1)) + "K"
	return str(floor(value))

func _on_mouse_entered_upgrade(data: Dictionary):
	var tipo = "Click" if data["type"] == "click" else "Passive"
	var power_text = format_val(data["power"])
	
	desc_label.text = "[ %s ]\nEffect: +%s per %s" % [data["name"], power_text, tipo]
	desc_label.modulate = Color(1, 1, 1, 1)

func _on_mouse_exited_upgrade():
	desc_label.text = "Hover over an upgrade for details..."
	desc_label.modulate = Color(1, 1, 1, 0.5)

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
	pass
