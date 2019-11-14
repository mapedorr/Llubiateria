extends Node2D

var time_count = 0

func _ready():
	$WorldTimer.connect("timeout", self, "_on_WorldTimer_timeout")
	$WorldTimer.start()
	

func _on_WorldTimer_timeout():
	Events.emit_signal("time_ticked")
	time_count += 1
	if time_count == 3:
		time_count = 0
		Events.emit_signal("hour_passed")


