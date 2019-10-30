extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")
	$Area2D.connect("body_exited", self, "_on_body_exited")
	Events.connect("battery_taken", self, "_on_battery_taken")

func _on_body_entered(body: PhysicsBody2D):
	Events.emit_signal("grab_entered")

func _on_body_exited(body: PhysicsBody2D):
	Events.emit_signal("grab_exited")

func _on_battery_taken():
	queue_free()