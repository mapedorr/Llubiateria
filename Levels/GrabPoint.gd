extends Node2D

enum OBJECTS {BATTERY, HEAD}
export (OBJECTS) var content
var resource = null
var battery = load("res://Objects/Battery/Battery.tscn")
var head = load("res://Objects/Junk/Head.tscn")
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if content == OBJECTS.BATTERY:
		resource = battery
	if content == OBJECTS.HEAD:
		resource = head
	$Area2D.connect("body_entered", self, "_on_body_entered")
	$Area2D.connect("body_exited", self, "_on_body_exited")
	Events.connect("object_taken", self, "_on_object_taken")

func _on_body_entered(body: PhysicsBody2D):
	Events.emit_signal("grab_entered", resource)
	active = true

func _on_body_exited(body: PhysicsBody2D):
	Events.emit_signal("grab_exited", resource)
	active = false

func _on_object_taken():
	if active:
		$Area2D.queue_free()