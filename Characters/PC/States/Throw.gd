extends "res://Main/StateMachine/State.gd"

"""
Controla el estado que permite al jugador lanzar objetos.
"""

""" ════ Funciones ═════════════════════════════════════════════════════════ """
func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func enter(msg: Dictionary = {}) -> void:
	.enter(msg)
	# TODO: disparar la animación de lanzar algo, poner un yield para esperar
	# a que termine y sólo entonces cambie al estado idle
	
	if _state_machine._previous_state == owner.STATES.JUMP:
		_state_machine.transition_to(owner.STATES.JUMP, msg)
	elif _state_machine._previous_state == owner.STATES.FALL:
		_state_machine.transition_to(owner.STATES.FALL, msg)
	else:
		_state_machine.transition_to(owner.STATES.IDLE)
		
func exit() -> void:
	.exit()
