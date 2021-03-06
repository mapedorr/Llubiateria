extends "res://Main/StateMachine/State.gd"

""" ════ Funciones ═════════════════════════════════════════════════════════ """
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	if _owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to(_owner.STATES.JUMP)
	
	if _owner.is_on_floor() and event.is_action_pressed("grab"):
		_state_machine.transition_to(_owner.STATES.GRAB)
		
	elif event.is_action_pressed("throw") and _owner.object_taken:
		_state_machine.transition_to(_owner.STATES.THROW)


func physics_process(delta: float) -> void:
	if _owner.is_on_floor() and _parent.get_move_direction().x != 0.0:
		_state_machine.transition_to(_owner.STATES.WALK)
	else:
		_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	.enter(msg)
	
	_parent.velocity = Vector2.ZERO
	
	_owner.play_animation(_owner.STATES.IDLE, _state_machine._previous_state)


func exit() -> void:
	.exit()
	_owner.stop_animation(_owner.STATES.IDLE)

