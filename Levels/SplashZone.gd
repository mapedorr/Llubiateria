tool
extends Position2D

export(int) var cell_size = 0
export(int) var left = 0 setget left_set
export(int) var right = 0 setget right_set
export(bool) var show_zone = false setget show_zone_set

var make_splash = false

func _ready():
	$EditorFeedback.hide()
	$EditorFeedback.points = PoolVector2Array([
		Vector2.LEFT * left * cell_size,
		Vector2.RIGHT * right * cell_size
	])
	Events.connect("rain_state_changed", self, "toggle_splash")
	$Timer.connect("timeout", self, "create_splash")

func _draw():
	$EditorFeedback.points[0].x = -1 * left * cell_size
	$EditorFeedback.points[1].x = right * cell_size

func left_set(new_val):
	left = new_val
	if not $EditorFeedback: return
	$EditorFeedback.points[0].x = -1 * left * cell_size

func right_set(new_val):
	right = new_val
	if not $EditorFeedback: return
	$EditorFeedback.points[1].x = right * cell_size

func toggle_splash(is_raining, _can_hurt):
	make_splash = is_raining
	if make_splash:
		$Timer.start()
	else:
		$Timer.stop()

func create_splash():
	if make_splash:
		$Particle.position.x = rand_range(
			$EditorFeedback.points[0].x,
			$EditorFeedback.points[1].x
		)
		$Particle.set_emitting(true)
		$Particle.restart()

func show_zone_set(new_val):
	show_zone = new_val
	if show_zone:
		$EditorFeedback.show()
	else:
		$EditorFeedback.hide()