extends RigidBody2D

""" ════ Variables ═════════════════════════════════════════════════════════ """
var picked = false
var picker = null
var pc = null

func _physics_process(delta):
	if picked:
		self.position = picker.get_node('./PC/GrabbingHand/GrabLocation').global_position

func _input(event):
	if Input.is_action_pressed("grab"):
		var bodies = $Pickable.get_overlapping_bodies()
		for body in bodies:
			if body.name == "PC" and picked == false:
				picker = body.get_owner()
				pc = picker.get_node('./PC')
				
				if not pc.object_taken:
					pc.object_taken = true
					set_picked(true)
				
	if event.is_action_pressed("throw") and picked == true:
		set_picked(false)
		pc = picker.get_node('./PC')
		pc.object_taken = false
		apply_impulse(Vector2(), Vector2(150*pc.get_node('GrabbingHand').current_dir.x, -40))
		
func set_picked(b):
	if b:
		picked = true
		set_mode(MODE_KINEMATIC)
		set_sleeping(true)
	else:
		picked = false;
		set_mode(MODE_RIGID)
		set_sleeping(false)