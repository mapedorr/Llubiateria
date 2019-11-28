extends "res://Main/StateMachine/State.gd"
"""
Properties
"""
const FALL_JUMP_TIME: = 0.09

var _fall_time: = 0.0
var on_safe_jump: = false
"""
Functions
"""
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	if _state_machine._previous_state == "Walk" or _state_machine._previous_state == "Idle":
		if _fall_time <= FALL_JUMP_TIME and event.get_action_strength("jump"):
			on_safe_jump = true
			_state_machine.transition_to("Move/Jump", { "safe_jump": true })


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)
	
	_fall_time += delta
	
	# Landing
	if owner.is_on_floor():
		var target_state: = "Move/Idle" if _parent.get_move_direction().x == 0 else "Move/Walk"
		_state_machine.transition_to(target_state)


func enter(msg: Dictionary = {}) -> void:
	_fall_time = 0.0
	on_safe_jump = false
	_parent.enter(msg)
	_parent.velocity.y = 1300.0
#	owner.get_node("FallParticle").set_emitting(false)


func exit() -> void:
	_fall_time = 0.0
	_parent.exit()
	
	if not on_safe_jump:
		owner.get_node("Audio/Fall").play()
		owner.get_node("FallParticle").set_emitting(true)
		owner.get_node("FallParticle").restart()