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
signal rain_state_changed(rain_state, area_state)

# Eventos de Metronomo ------------------------------------------------------------
signal bar_started(current_bar)
signal half_ticked(current_bar)
signal quarter_ticked(current_bar)
signal eight_ticked(current_bar)
signal sixteenth_ticked(current_bar)
