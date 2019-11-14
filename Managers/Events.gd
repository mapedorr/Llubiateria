# Contiene todas las señales del juego
extends Node

# Eventos del mundo ------------------------------------------------------------
signal time_ticked
signal hour_passed
signal damage_inflicted
signal grab_entered(resource)
signal grab_exited
signal object_taken
signal enfermita_dead
signal object_collided(current_pos)