extends TextureButton

@onready var main_scene: Control = $".."
@onready var indicators: Control = $"../Indicators"
@onready var template: Label = $"../Indicators/Template"

func _on_pressed():
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	
	self.modulate = Color(1.089, 1.027, 0.807, 1.0)
	tween.finished.connect(func(): self.modulate = Color(1.0, 1.0, 1.0, 1.0))


func _on_main_scene_coin_clicked(amount) -> void:
	var indicator = template.duplicate()
	indicator.text= "+"+str(amount)
	indicator.position = get_global_mouse_position()
	indicator.visible = true
	indicators.add_child(indicator)
	indicator.get_child(0).start()
