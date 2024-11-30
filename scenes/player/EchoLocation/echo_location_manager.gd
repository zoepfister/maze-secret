extends Node2D

var circle_scene = preload("res://scenes/player/EchoLocation/EcholocationWave.tscn")
var active_circles = []
var circle_speed = 100
var spawn_interval = 5 # seconds
var time_since_last_spawn = 0
var action_locked = false

@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	time_since_last_spawn += delta
	if Input.is_action_pressed("echolocateI") and Input.is_action_pressed("echolocateJ") and not action_locked:
		#print_debug("Echolocation pressed")
		action_locked = true
		spawn_circle()
		time_since_last_spawn = 0
	
	if time_since_last_spawn > spawn_interval:
		action_locked = false
	
	for circle in active_circles:
		circle.radius += circle_speed * delta
		if circle.alpha <= -.3:
			circle.queue_free()
			active_circles.erase(circle)
			#print_debug("Circle removed")

func spawn_circle():
	var new_circle = circle_scene.instantiate()
	active_circles.append(new_circle)
	add_child(new_circle)
