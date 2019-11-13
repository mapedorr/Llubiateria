extends KinematicBody2D

export (int) var object_gravity = 5
export (int) var object_speed = 5
export (float) var object_angle = 350

var _gravity = 10
var _movement = Vector2()
var object_thrown = false
var directional_force = Vector2()
var original_pos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Pickable.connect("body_entered", self, "_on_body_entered")

func _process(delta):
	if object_thrown:
		move_and_slide(Vector2 (200,200), Vector2(0,-10))

func grab_object(position):
	original_pos = position
	set_position(original_pos)

func throw_object(position):
	original_pos = position
	object_thrown = true

func _on_body_entered(other):
	if other.get_name() == "PC":
		grab_object(original_pos)
		object_thrown = false
		other.object_taken = true



