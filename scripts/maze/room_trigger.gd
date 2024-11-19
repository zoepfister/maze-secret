extends Area2D
class_name RoomTrigger

var camera_trigger : CollisionShape2D
var viewport_camera : Camera2D
@export var zooming_speed : float = 0.01
@export var room_zoom : Vector2 = Vector2(0.7, 0.7)
var initial_zoom : Vector2
var player_entered_room : bool = false

func set_size(size : Vector2) -> void :
	var rect = camera_trigger.shape as RectangleShape2D
	rect.size = size

func _ready() -> void:
	camera_trigger = $CameraTrigger
	viewport_camera = get_viewport().get_camera_2d()	# Player Camera2D
	initial_zoom = viewport_camera.zoom
	
func _process(delta: float) -> void:
	if player_entered_room :
		viewport_camera.zoom = lerp(viewport_camera.zoom, room_zoom, zooming_speed)
	else :
		viewport_camera.zoom = lerp(viewport_camera.zoom, initial_zoom, zooming_speed)
	
func _on_body_entered(body: Node2D) -> void: 
	if body.name == "Protagonist":
		player_entered_room = true
		
func _on_body_exited(body: Node2D) -> void:
	if body.name == "Protagonist":
		player_entered_room = false
