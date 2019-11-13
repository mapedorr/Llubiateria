extends Node2D

export var rain_cooldown = 5
export var rain_duration = 3

var is_raining = false 
var can_hurt = false

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
	$SafeZones.connect("body_entered", self, "_on_body_entered")
	$SafeZones.connect("body_exited", self, "_on_body_exited")
	
func _on_time_ticked():
	if is_raining:
		rd -= 1
		if rd == 0:
			stop_rain()
		
		rain_damage()
		
	else:
		rc -= 1
		if rc == 1:
			print ('Va a llover')
		if rc == 0:
			start_rain()

func start_rain():
	rc = rain_cooldown
	$Lluvia.set_emitting(true)
	is_raining = true

func stop_rain():
	rd = rain_duration
	$Lluvia.set_emitting(false)
	is_raining = false

func rain_damage():
	if can_hurt:
		Events.emit_signal("damage_inflicted")
	
func _on_body_entered(body):
	print("Buena la rata")
	can_hurt = false
	
func _on_body_exited(body):
	print("Pilas gonorrea, ¡se va a derretir!")
	can_hurt = true
