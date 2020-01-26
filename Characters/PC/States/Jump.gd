extends "res://Main/StateMachine/State.gd"

""" ════ Variables ═════════════════════════════════════════════════════════ """
export var boost: = Vector2(2.0, 0.0)

var is_jump_interrupted: = false

""" ════ Funciones ═════════════════════════════════════════════════════════ """
func unhandled_input(event: InputEvent) -> void:

	
	if event.is_action_pressed("throw") and owner.object_taken:
		_state_machine.transition_to(owner.STATES.THROW, {"velocity": _parent.velocity})

func physics_process(delta: float) -> void:
	_parent.physics_process(delta)

	if is_jump_interrupted:
		_state_machine.transition_to(owner.STATES.FALL, { "jump_interrupted": true })
	elif _parent.velocity.y > 0.0:
		if not owner.is_on_floor():
			_state_machine.transition_to(owner.STATES.FALL, { "jump_interrupted": false })


func enter(msg: Dictionary = {}) -> void:
	.enter(msg)

	is_jump_interrupted = false
	if msg.has("safe_jump"):
		# Poner la velocidad en Y a 0.0 para que se eleve el PC cuando se ha
		# saltado justo después de dejar una plataforma
		_parent.velocity.y = 0.0
	
	if "velocity" in msg:
		_parent.velocity = msg["velocity"]
	else:
		_parent.velocity += calculate_jump_velocity()
	
	owner.play_animation(owner.STATES.JUMP)


func exit() -> void:
	.exit()


"""
Returns a new velocity with a vertical impulse applied to it
"""
func calculate_jump_velocity() -> Vector2:
	return _parent.calculate_move_velocity(
		_parent.velocity,
		Vector2.UP,
		_parent.speed,
		1.0,
		1.0
	)
