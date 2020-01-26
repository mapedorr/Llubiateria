extends "res://Main/StateMachine/State.gd"

""" ════ Variables ═════════════════════════════════════════════════════════ """
# Si el valor de _fall_time supera este valor cuando se abandone este estado,
# entonces el PJ habrá caído desde un punto alto.
export(float) var long_fall_treshold = 0.3

const FALL_JUMP_TIME: = 0.15

var _fall_time: = 0.0
var _is_safe_jump: = false

""" ════ Funciones ═════════════════════════════════════════════════════════ """
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	if _state_machine._previous_state == owner.STATES.WALK or _state_machine._previous_state == owner.STATES.IDLE:
		if _fall_time <= FALL_JUMP_TIME and event.get_action_strength("jump"):
			_is_safe_jump = true
			_state_machine.transition_to(owner.STATES.JUMP, { "safe_jump": true })
	
	if event.is_action_pressed("throw") and owner.object_taken:
		_state_machine.transition_to(owner.STATES.THROW, {"velocity": _parent.velocity})

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	
	_fall_time += delta
	
	# Landing
	if owner.is_on_floor():
		var target_state: String = owner.STATES.IDLE if _parent.get_move_direction().x == 0 else owner.STATES.WALK
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	.enter(msg)

	_fall_time = 0.0
	_is_safe_jump = false
	_parent.velocity.y = 1300.0
	owner.play_animation(owner.STATES.FALL)
#	owner.get_node("FallParticle").set_emitting(false)


func exit() -> void:
	.exit()
	
	if not _is_safe_jump:
		if _fall_time >= long_fall_treshold:
			# TODO: poner la retroalimentación de una caída alta
			print("¡Ay gran hijueputa me voy a mataaaaar!")

		owner.play_animation(owner.STATES.CONTACT)
	
	# reinicar algunas variales a su valor por defecto
	_fall_time = 0.0