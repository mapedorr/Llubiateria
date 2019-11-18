extends Node2D

onready var tween_out = $Fade

export var fadein_duration = 3
export var fadeout_duration = 8
export var transition_type = 0

export var rain_cooldown = 5
export var rain_duration = 3

var is_raining = false 
var can_hurt = false
var fading_in = false

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
	$Fade.connect("tween_completed", self, "_on_tween_completed")
	
func _on_time_ticked():
	if is_raining:
		rd -= 1
		if rd == 0:
			stop_rain()
		
		rain_damage()
		
	else:
		rc -= 1
		if rc == 1:
			$SFX_Alarm.play()
			Events.emit_signal("rain_state_changed", true, can_hurt)
			print ('Va a llover')
		if rc == 0:
			start_rain()

func start_rain():
	
	rc = rain_cooldown
	$Lluvia.set_emitting(true)
	$SFX_Rain.play()
	fade_in($SFX_Rain, 0.5)
	is_raining = true

func stop_rain():
	$SFX_Alarm.stop()
	fade_out($SFX_Rain, 5.2)
	rd = rain_duration
	$Lluvia.set_emitting(false)
	is_raining = false
	Events.emit_signal("rain_state_changed", is_raining, can_hurt)

func rain_damage():
	if can_hurt:
		Events.emit_signal("damage_inflicted")
	
func _on_body_entered(body):
	if body.get_name() == "PC":
		print("Buena la rata")
		can_hurt = false
		body.activate_rain_alarm(is_raining, can_hurt)
	else:
		return
	
func _on_body_exited(body):
	if body.get_name() == "PC":
		can_hurt = true
		body.activate_rain_alarm(is_raining, can_hurt)
		print("Pilas gonorrea, ¡se va a derretir!")
	else:
		return
	

func fade_in(music_to_fade, fadein_duration):
	fading_in = true
	tween_out.interpolate_property(music_to_fade, "volume_db", music_to_fade.volume_db, 0, fadein_duration, transition_type, Tween.EASE_OUT, 1)
	tween_out.start()

func fade_out(music_to_fade, fadeout_duration):
	fading_in = false
	tween_out.interpolate_property(music_to_fade, "volume_db", music_to_fade.volume_db, -80, fadeout_duration, transition_type, Tween.EASE_OUT, 1)
	tween_out.start()


func _on_tween_completed(music_to_fade, key):
	if not fading_in:
		music_to_fade.stop()
