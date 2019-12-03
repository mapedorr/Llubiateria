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
	owner.throw()
	# TODO: disparar la animación de lanzar algo, poner un yield para esperar
	# a que termine y sólo entonces cambie al estado idle
	_state_machine.transition_to("Move/Idle")


func exit() -> void:
	.exit()
