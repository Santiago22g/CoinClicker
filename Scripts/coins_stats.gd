extends Label

@onready var coin_label: Label = $"."


func _on_main_scene_coins_changed(amount) -> void:
	coin_label.text = str(amount) + " Coins"
