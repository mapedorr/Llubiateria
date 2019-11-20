extends "res://Main/StateMachine/State.gd"

#onready var jump_delay: Timer = $JumpDelay

func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Jump")
	else:
		_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	if owner.is_on_floor() and _parent.get_move_direction().x != 0.0:
		_state_machine.transition_to("Move/Walk")
#	elif not owner.is_on_floor():
		# Aquí podría entrar a la caída
#		_state_machine.transition_to("Move/Air")
	else:
		_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	_parent.enter(msg)

	_parent.velocity = Vector2.ZERO
#	if jump_delay.time_left > 0.0:
#		_state_machine.transition_to("Move/Air")


func exit() -> void:
	_parent.exit()