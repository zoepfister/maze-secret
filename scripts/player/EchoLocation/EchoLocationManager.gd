extends Node2D

var circle_scene = preload("res://scripts/player/EchoLocation/EcholocationWave.tscn")
var active_circles = []
var circle_speed = 100
var spawn_interval = 0.5
var time_since_last_spawn = 0

@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	time_since_last_spawn += delta
	if Input.is_action_just_pressed("echolocate"):
		print_debug("Echolocation pressed")
		spawn_circle()
		time_since_last_spawn = 0
	
	for circle in active_circles:
		circle.radius += circle_speed * delta
	
	if time_since_last_spawn > 5.0:
		for circle in active_circles:
			circle.queue_free()
		active_circles.clear()

func spawn_circle():
	var new_circle = circle_scene.instantiate()
	active_circles.append(new_circle)
	add_child(new_circle)
