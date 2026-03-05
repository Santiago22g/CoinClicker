extends Control

var coins = 0
var amount_per_click = 1
@onready var sonido_click = $CoinSound

signal coins_changed

func _on_texture_button_pressed() -> void:
	sonido_click.play()
	coins += amount_per_click
	emit_signal("coins_changed", coins)
