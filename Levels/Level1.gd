extends Node2D

enum STATES {
	PLAYING,
	PAUSED,
	LOST,
	WON
}

func _ready():
	Events.connect("enfermita_dead", self, "_on_enfermita_dead")
	Events.connect("character_dead", self, "_on_enfermita_dead")
		
var seconds_for_completion = 120

var current_state = STATES.PLAYING

func set_state(state):
	match state:
		STATES.PLAYING:
			if get_tree().paused:
				get_tree().paused = false
				$TextLayer.get_node("StateText").set_visible(false)
		STATES.PAUSED:
			if not get_tree().paused:
				get_tree().paused = true
				$TextLayer.get_node("StateText").set_text("PAUSED")
				$TextLayer.get_node("StateText").set_visible(true)
		STATES.LOST:
			if not get_tree().paused:
				get_tree().paused = true
				$TextLayer.get_node("StateText").set_text("YOU LOST!")
				$TextLayer.get_node("StateText").set_visible(true)
		STATES.WON:
			if not get_tree().paused:
				get_tree().paused = true
				$TextLayer.get_node("StateText").set_text("YOU WON!")
				$TextLayer.get_node("StateText").set_visible(true)
	
	current_state = state

func _on_enfermita_dead():
	set_state(STATES.LOST)