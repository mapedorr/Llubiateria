extends Node2D
""" ════ Variables ═════════════════════════════════════════════════════════ """
onready var tween_out = $Fade

export var fadein_duration: int = 3
export var fadeout_duration: int = 8
export var transition_type: int = 0
export var rain_cooldown: int = 5
export var minRC: int = 6
export var maxRC: int = 15
export var rain_duration: int = 3
export var minRD: int = 4
export var maxRD: int = 20
export var ticks_to_damage: int = 4

var is_raining = false
var can_hurt = false
var fading_in = false

onready var rc: int = int(rand_range( minRC, (maxRC)))
onready var rd: int = int(rand_range( minRD, (maxRD)))
onready var damage_counter: int = ticks_to_damage
""" ════ Funciones ═════════════════════════════════════════════════════════ """
func _ready():
	if is_raining == false:
		$Lluvia.set_emitting(false)
	else:
		$Lluvia.set_emitting(true)
	Events.connect("time_ticked", self, "_on_time_ticked")
	$SafeZones.connect("body_entered", self, "_on_body_entered")
	$SafeZones.connect("body_exited", self, "_on_body_exited")
	$Fade.connect("tween_completed", self, "_on_tween_completed")

	# Para que se muestre sí o sí cuando el juego inicia
	show()


func _on_time_ticked():
	if is_raining:
		rd -= 1
		if rd == 0:
			stop_rain()

		damage_counter -= 1
		if damage_counter == 0:
			damage_counter = ticks_to_damage
			rain_damage()
	else:
		rc -= 1
		if rc == 1:
			$SFX_Alarm.play()
			Events.emit_signal("rain_state_changed", true, can_hurt)
		if rc == 0:
			start_rain()


func start_rain():
	damage_counter = ticks_to_damage
	rc = int(rand_range( minRC, (maxRC)))
	$Lluvia.set_emitting(true)
	$SFX_Rain.play()
	fade_in($SFX_Rain, 0.5)
	is_raining = true


func stop_rain():
	$SFX_Alarm.stop()
	fade_out($SFX_Rain, 3)
	rd = int(rand_range( minRD, (maxRD)))
	$Lluvia.set_emitting(false)
	is_raining = false
	Events.emit_signal("rain_state_changed", false, can_hurt)


func rain_damage():
	if can_hurt:
		Events.emit_signal("damage_inflicted")


func _on_body_entered(body):
	if body.get_name() == "PC":
		can_hurt = false
		body.activate_rain_alarm(is_raining, can_hurt)
	else:
		return


func _on_body_exited(body):
	if body.get_name() == "PC":
		can_hurt = true
		body.activate_rain_alarm(is_raining, can_hurt)
	else:
		return


func fade_in(sound_to_fade, fadein_duration):
	fading_in = true
	tween_out.interpolate_property(
		sound_to_fade,
		"volume_db",
		sound_to_fade.volume_db,
		-6,
		fadein_duration,
		transition_type,
		Tween.EASE_OUT,
		1
	)
	tween_out.start()

func fade_out(sound_to_fade, fadeout_duration):
	fading_in = false
	tween_out.interpolate_property(
		sound_to_fade,
		"volume_db",
		sound_to_fade.volume_db,
		-80,
		fadeout_duration,
		transition_type,
		Tween.EASE_OUT,
		1
	)
	tween_out.start()


func _on_tween_completed(sound_to_fade, key):
	if fading_in:
		return
	else:
		sound_to_fade.stop()

