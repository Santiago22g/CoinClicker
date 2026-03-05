extends Control

var coins = 0
var amount_per_click = 1
var multiplier = 1
var is_frenzy_active = false
var drain_speed = 15.0 

@onready var click_sound = $CoinSound
@onready var coin_meter = $TextureProgressBar 
@onready var total_label = $CoinTotal 
@onready var bg_panel = $Panel
@onready var main_background = $TextureRect

signal coins_changed
signal coin_clicked

func _ready() -> void:
	bg_panel.visible = false

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
