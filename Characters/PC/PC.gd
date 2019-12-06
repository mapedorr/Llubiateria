extends Actor

""" ════ Variables ═════════════════════════════════════════════════════════ """
enum ANIMS { IDLE, WALK, JUMP, FALL }

var health: = 100
var can_take_object: = false
var object_resource:Resource = null
var object_taken: = false
var extra_weight: = 0.0


""" ════ Funciones ═════════════════════════════════════════════════════════ """
func _ready():
	# Asignar valores iniciales
	$Health.value = health
	# Conectar escuchadores de señales
	Events.connect("damage_inflicted", self, "damage_character")
	Events.connect("grab_entered", self, "_on_grab_toggle", [ true ])
	Events.connect("grab_exited", self, "_on_grab_toggle", [ false ])
	Events.connect("rain_state_changed", self, "activate_rain_alarm")

"""
Responde a la señal de haber entrado en colisión con un GrabPoint.
En la colisión de entrada guarda el recurso del objeto asociado al GrabPoint para
luego instanciarlo si se presiona la tecla de agarre (jump).
En la colisión de salida limpia el recurso y deshabilita la condisión que reemplaza
el salto por el agarre (can_take_object).
"""
func _on_grab_toggle (resource, new_value):
	object_resource = resource
	can_take_object = new_value


func activate_rain_alarm(rain_state, area_state):
	if rain_state == true:
		$Sprite/Danger.visible = area_state
		if area_state:
			$Audio/RainZone.play()
	else:
		if area_state:
			yield(get_tree().create_timer(1.8),"timeout")
			$Sprite/Danger.visible = false


func damage_character():
	if health != 0:
		health -= 10
		$Health.value = health
	else:
#		$Death.play()
		Events.disconnect("damage_inflicted", self, "damage_character")
		Events.disconnect("grab_entered", self, "_on_grab_toggle")
		Events.disconnect("grab_exited", self, "_on_grab_toggle")
		Events.disconnect("rain_state_changed", self, "activate_rain_alarm")
		print('ya estoy muerto, ¡qué dolor tan triplehijueputa!')


func has_object():
	return $GrabbingHand.object_taken


func recover_object(object_node):
	$GrabbingHand.recover_object(object_node)
	extra_weight += object_node.gravity


func play_animation(code, previous_state = ""):
	match code:
		ANIMS.IDLE:
			if previous_state == "Walk":
				$Audio/Stop.play()
			$Sprite/AnimationPlayer.play("Idle")
		ANIMS.WALK:
			$Sprite/AnimationPlayer.play("Walk")
		ANIMS.JUMP:
			$Audio/Jump.play()
			$Sprite/AnimationPlayer.play("Idle")


func stop_animation(code):
	pass

"""
Hace que el personaje agarre un objeto y lo cargue. El peso del objeto hará que
se altere la altura del salto (velocidad de movimiento en -Y) en el personaje.
"""
func take():
	$GrabbingHand.take_object(object_resource)
	extra_weight += $GrabbingHand.current_object.gravity


func throw():
	if can_take_object == false:
		$GrabbingHand.throw_object()
		extra_weight = 0.0