extends Node

func _input(event):
	var level = get_parent()
	if Input.is_action_pressed("pause"):
		if level.current_state == level.STATES.PLAYING:
			level.set_state(level.STATES.PAUSED)
		elif level.current_state == level.STATES.PAUSED:
			level.set_state(level.STATES.PLAYING)