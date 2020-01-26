extends Sprite

var dflt_pos = Vector2.ZERO
var dir = 0

func _ready() -> void:
	update_dflt_pos()

func update_dflt_pos():
	dir = -1 if is_flipped_h() else 1
	dflt_pos = position

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
