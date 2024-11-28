extends Area2D

@onready var player_camera: Camera2D = get_tree().get_first_node_in_group("player_camera")

@export var offset: float = 600.0
@export var movement_speed: float = 1.0

var camera_initial_offset_x: float
var peeking_offset: float
var is_peeking = false

func _ready() -> void:
	camera_initial_offset_x = player_camera.offset.x
	peeking_offset = camera_initial_offset_x + offset
	
func _process(delta: float) -> void:
	if is_peeking:
		player_camera.offset.x = lerp(
			player_camera.offset.x,
			peeking_offset,
			movement_speed * delta 
			)
	else:
		player_camera.offset.x = lerp(
			player_camera.offset.x,
			camera_initial_offset_x,
			movement_speed * delta 
			)

func _on_body_entered(body: Node2D) -> void:
	is_peeking = true

func _on_body_exited(body: Node2D) -> void:
	is_peeking = false
