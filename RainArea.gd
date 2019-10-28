extends Node2D

export var rain_cooldown = 5
export var rain_duration = 3

var is_raining = false 

var rc
var rd

func _ready():
	rc = rain_cooldown
	rd = rain_duration
	if is_raining == false:
		$Lluvia.set_emitting(false)
	else:
		$Lluvia.set_emitting(true)
	Events.connect("time_ticked", self, "_on_time_ticked")

func _on_time_ticked():
	if is_raining:
		rd -= 1
		if rd == 0:
			stop_rain()
			print ('dejo de llover')
		
		rain_damage()
		
	else:
		rc -= 1
		if rc == 1:
			print ('Va a llover')
		if rc == 0:
			start_rain()
			print ('se vino el agua')

func start_rain():
	rc = rain_cooldown
	$Lluvia.set_emitting(true)
	is_raining = true
	


func stop_rain():
	rd = rain_duration
	$Lluvia.set_emitting(false)
	is_raining = false

func rain_damage():
	Events.emit_signal("damage_inflicted")
	print ('te dano perro')
