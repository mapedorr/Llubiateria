extends RigidBody2D

""" ════ Variables ═════════════════════════════════════════════════════════ """
var picked = false
var picker = null

func _input(event):
	if Input.is_action_just_pressed("e"):
		var bodies = $Pickable.get_overlapping_bodies()
		for body in bodies:
			if body.name == "PC" and picked == false:
				picker = body.get_owner()
				set_picked(true)
			
	if event.is_action_pressed("throw") and picked == true:
		set_picked(false)
		apply_impulse(Vector2(), Vector2(200, -50))		
		
func set_picked(b):
	if b:
		picked = true
		set_mode(MODE_KINEMATIC)
		set_sleeping(true)
		picker.object_taken = true
	else:
		picked = false;
		picker.object_taken = false
		set_mode(MODE_RIGID)
		set_sleeping(false)
		
func initialize(info):
	self.position = info["position"]