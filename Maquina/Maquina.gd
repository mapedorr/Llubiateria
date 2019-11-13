extends Node2D

var battery_life = 100
var enfermita_alive = true

func _ready():
	# Conectar eventos
	$BatteryArea.connect("body_entered", self, "_on_body_entered")
	Events.connect("hour_passed", self, "_on_hour_passed")
	
	# Actualizar valores
	$BatteryLife.value = battery_life

func _on_hour_passed():
	battery_life -= 20
	$BatteryLife.value = battery_life
	
	if battery_life == 0:
		Events.disconnect("hour_passed", self, "_on_hour_passed")
		$Enfermita.battery_dead()
		enfermita_alive = false

func _on_body_entered(other):
	if other.get_name() == "Battery":
		battery_life = 100
		$BatteryLife.value = battery_life
		if enfermita_alive:
			$Enfermita.battery_alive()
		Events.connect("hour_passed", self, "_on_hour_passed")
	else:
		print ('salga rana piroba')