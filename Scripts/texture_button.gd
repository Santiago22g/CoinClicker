extends TextureButton

func _on_pressed():
	var tween = create_tween()
	
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	
	self.modulate = Color(1.089, 1.027, 0.807, 1.0)
	tween.finished.connect(func(): self.modulate = Color(1.0, 1.0, 1.0, 1.0))
