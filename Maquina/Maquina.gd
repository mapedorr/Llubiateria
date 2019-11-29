extends Node2D

var battery_life = 100
var enfermita_alive = true

func _ready():
	# Conectar eventos
	$BatteryArea.connect("body_entered", self, "_on_body_entered")
	Events.connect("hour_passed", self, "_on_hour_passed")
	Events.connect("enfermita_dead", self, "_on_enfermita_dead")
	
	# Actualizar valores
	$BatteryLife.value = battery_life

func _on_hour_passed():
	battery_life -= 10
	$BatteryLife.value = battery_life
	
	if battery_life == 0:
		Events.disconnect("hour_passed", self, "_on_hour_passed")
		if enfermita_alive:
			$Enfermita.battery_dead()

func _on_body_entered(other):
	if other.get_name() == "Battery":
		other.queue_free()
		$Pila.visible = true
		battery_life = 100
		$BatteryLife.value = battery_life
		$Reactivate.play()
		if enfermita_alive:
			$Enfermita.battery_alive()
		Events.connect("hour_passed", self, "_on_hour_passed")
	else:
		print ('salga rana piroba')

func _on_enfermita_dead():
	enfermita_alive = false