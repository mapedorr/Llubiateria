extends Sprite

onready var init_pos: Vector2 = position
var dflt_pos: Vector2 = Vector2.ZERO
var dir: = 0

func _ready() -> void:
	update_dflt_pos()


func update_dflt_pos():
	dir = -1 if is_flipped_h() else 1
	dflt_pos = position


func flip(x_dir: int):
	set_flip_h(x_dir < 0)
	set_position(Vector2(init_pos.x * x_dir, init_pos.y))
	update_dflt_pos()


""" ──── Funciones para coordinar con animación IDLE ─────────────────────── """
func idle_0():
	position = dflt_pos


func idle_1():
	position.y = dflt_pos.y + 4


func idle_2():
	position.x = dflt_pos.x + 4 * dir


func idle_3():
	position.y = dflt_pos.y
""" ──────────────────────────────────────────────────────────────────────── """

""" ──── Funciones para coordinar con animación WALK ─────────────────────── """
func walk_down():
	# Para cuando el robot da un paso que lo hace subir
	position.y = dflt_pos.y + 4


func walk_up():
	# Para cuando el robot da un paso que lo hace bajar
	position.y = dflt_pos.y
""" ──────────────────────────────────────────────────────────────────────── """
