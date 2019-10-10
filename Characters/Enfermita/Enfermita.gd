extends Node2D

var health = 100
var battery_life = 100
var shake = false
var shake_amount = 10.0
var timer = 0
var dolores = 0

onready var start_position = $Sprite.get_position()

func _ready():
	# Conectar eventos
	Events.connect("hour_passed", self, "_on_hour_passed")
	
	# Actualizar valores
	$BatteryLife.value = battery_life

func _process(delta):
	if shake:
		timer += 1
		$Sprite.set_position(
			start_position + Vector2(rand_range(-1.0, 1.0) * shake_amount, rand_range(-1.0, 1.0) * shake_amount)
		)
	if timer >= 10:
		shake = false
		timer = 0
		$Sprite.set_position(start_position)

func _on_hour_passed():
	battery_life -= 20
	$BatteryLife.value = battery_life
	$Tos.play()
	shake = true
	
	if battery_life == 0:
		shake_amount *= 2.0
		Events.disconnect("hour_passed", self, "_on_hour_passed")
		Events.connect("time_ticked", self, "_on_time_ticked")

func _on_time_ticked():
	health -= 25.0
	shake = true
	shake_amount -= 5
	$Sprite.set_self_modulate(Color(1.0, 1.0, 1.0, health / 100.0))
	dolores += 1
	if dolores <= 3:
		get_node("Dolor%d"%dolores).play()

	if health == 0:
		$Muerte.play()
		$Muerte.connect("finished", self, "queue_free")
		Events.disconnect("time_ticked", self, "_on_time_ticked")
		print("Me moríiiiiiiiiiiii")