extends Area2D

export (String) var area = null

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(other):
	if other.get_name() == "PC":
		other.get_node("Audio").set_reverb_zone(area)