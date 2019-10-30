extends Actor

var health = 100
var can_take_battery = false
var battery_resource = load("res://Battery/Battery.tscn")
var battery = null

func _ready():
	Events.connect("damage_inflicted", self, "damage_character")
	Events.connect("grab_entered", self, "_on_grab_toggle", [ true ])
	Events.connect("grab_exited", self, "_on_grab_toggle", [ false ])

func _on_grab_toggle (new_value):
	can_take_battery = new_value

func _physics_process(delta):
	if can_take_battery and Input.is_action_just_pressed("jump"):
		self.take_battery()
		return
	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	$Health.value = health
	var direction: = get_direction()
	_velocity = calculate_move_velocity(
		_velocity,
		direction,
		speed,
		is_jump_interrupted
	)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.get_action_strength("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity

func damage_character():
	if health != 0:
		health -= 10
	else:
		print('ya estoy muerto, que dolor')

func take_battery():
	battery = battery_resource.instance()
	battery.set_position($BatteryLocation.get_position())
	add_child(battery)
	Events.emit_signal("battery_taken")
	can_take_battery = false