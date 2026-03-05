extends Control

var coins = 0
var amount_per_click = 1

signal coins_changed

func _on_texture_button_pressed() -> void:
	coins += amount_per_click
	emit_signal("coins_changed", coins)
