extends Actor
class_name PC

""" ════ Variables ═════════════════════════════════════════════════════════ """
const STATES = { 
	IDLE="Move/Idle", 
	WALK="Move/Walk", 
	JUMP="Move/Jump", 
	FALL="Move/Fall", 
	CONTACT="Contact",
	GRAB="Grab",
	THROW="Throw",
}

var health: int = 100
var can_take_object: = false
var object_resource:Resource = null
var object_taken: = false
var extra_weight: = 0.0
var can_move: = true
var has_to_flip: = false


""" ════ Funciones ═════════════════════════════════════════════════════════ """
func _ready():
	# Asignar valores iniciales
	$LifeTank.set_value(health)
	
	# Conectar escuchadores de señales
	Events.connect("damage_inflicted", self, "damage_character")
	Events.connect("grab_entered", self, "_on_grab_toggle", [ true ])
	Events.connect("grab_exited", self, "_on_grab_toggle", [ false ])
	Events.connect("rain_state_changed", self, "activate_rain_alarm")
	$Sprite/AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

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
		$RainDetector.set_frame(1 if area_state else 0)
		if area_state:
			$Audio/RainZone.play()
	else:
		$RainDetector.set_frame(0)
		if area_state:
			yield(get_tree().create_timer(1.8),"timeout")


func damage_character():
	if health != 0:
		health -= 20
		$LifeTank.set_value(health)
	else:
		Events.disconnect("damage_inflicted", self, "damage_character")
		Events.disconnect("grab_entered", self, "_on_grab_toggle")
		Events.disconnect("grab_exited", self, "_on_grab_toggle")
		Events.disconnect("rain_state_changed", self, "activate_rain_alarm")
		Events.emit_signal("character_dead")


func has_object():
	return $GrabbingHand.object_taken


func recover_object(object_node):
	$GrabbingHand.recover_object(object_node)
	extra_weight += object_node.gravity


func play_animation(code, previous_state = ""):
	match code:
		STATES.IDLE:
			if previous_state == "Walk":
				$Audio/Stop.play()
			if $Sprite/AnimationPlayer.current_animation != "Contact":
				$Sprite/AnimationPlayer.play("Idle")
		STATES.WALK:
			if $Sprite/AnimationPlayer.current_animation != "Contact":
				if has_to_flip:
					has_to_flip = false
					$Sprite/AnimationPlayer.play("Flip")
					yield($Sprite/AnimationPlayer, "animation_finished")
				$Sprite/AnimationPlayer.play("Walk")
		STATES.JUMP:
			$Audio/Jump.play()
			$Sprite/AnimationPlayer.play("Jump")
		STATES.FALL:
			$Sprite/AnimationPlayer.play("Fall")
		STATES.CONTACT:
			$Audio/Fall.play()
			$FallParticle.set_emitting(true)
			$FallParticle.restart()
			can_move = false;
			$Sprite/AnimationPlayer.play("Contact")
			yield($Sprite/AnimationPlayer, "animation_finished")
			can_move = true


func stop_animation(code):
	pass

func on_animation_finished(animation_name):
	if animation_name == "Contact":
		if $StateMachine.state.name == "Idle":
			$Sprite/AnimationPlayer.play("Idle")
		elif $StateMachine.state.name == "Walk":
			$Sprite/AnimationPlayer.play("Walk")

"""
Hace que el personaje agarre un objeto y lo cargue. El peso del objeto hará que
se altere la altura del salto (velocidad de movimiento en -Y) en el personaje.
"""
func take():
	"""$GrabbingHand.take_object(object_resource)"""
	"""extra_weight += $GrabbingHand.current_object.gravity"""

func flip(x_dir):
	has_to_flip = true
	$GrabbingHand.current_dir = Vector2(x_dir, -1.0)
	$Sprite.set_flip_h(x_dir < 0)
	$RainDetector.flip(x_dir)
	$LifeTank.flip(x_dir)