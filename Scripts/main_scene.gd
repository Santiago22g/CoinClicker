extends Control

@onready var sonido_click = $CoinSound
@onready var particulas = $CPUParticles2D 

func _on_texture_button_pressed():
	sonido_click.play()
	
	# En lugar de usar la posición del ratón, vamos a centrarlas
	# para ver si aparecen en el centro de la pantalla (ajusta 500, 300 a tu resolución)
	particulas.global_position = Vector2(500, 300)
	
	particulas.restart()
	particulas.emitting = true
	
	# Esto te dirá en la consola si el código se está ejecutando
	print("Botón pulsado. Partículas activas: ", particulas.emitting)
