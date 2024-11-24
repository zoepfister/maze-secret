extends Area2D
class_name RoomTrigger

@onready var player_camera: Camera2D = get_tree().get_first_node_in_group("player_camera")
@onready var player: Player = get_tree().get_first_node_in_group("player")

@export var solver: Node2D		# entity that signal when the room is solved
@export_group("Camera settings")
@export var zooming_speed: float = 1.0
@export var room_zoom: Vector2 = Vector2(0.7, 0.7)
@export_group("Hints")
@export var hints: Array[String] = []

var camera_trigger: CollisionShape2D
var initial_zoom: Vector2
var player_entered_room: bool = false
var is_room_solved: bool = false

func set_size(size: Vector2) -> void :
	var rect = camera_trigger.shape as RectangleShape2D
	rect.size = size

func _ready() -> void:
	camera_trigger = $CameraTrigger
	initial_zoom = player_camera.zoom
	if solver != null:
		solver.room_solved.connect(_on_room_solved)
	
func _on_room_solved():
	is_room_solved = true
	
func _process(delta: float) -> void:
	if player_entered_room :
		player_camera.zoom = lerp(player_camera.zoom, room_zoom, zooming_speed * delta)
	else :
		player_camera.zoom = lerp(player_camera.zoom, initial_zoom, zooming_speed * delta)
	
func _on_body_entered(body: Node2D) -> void: 
	player_entered_room = true
	if !is_room_solved:
		_show_hint()
		
func _on_body_exited(body: Node2D) -> void:
	player_entered_room = false
	
func _show_hint() -> void:
	DialogManager.start_dialog(player, hints)
