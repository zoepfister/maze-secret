extends Area2D

var camera_trigger : CollisionShape2D
var direction_sign_on_entered : Vector2
var visited : bool = false
var viewport_camera : Camera2D
@export var zooming_speed : float = 0.01
@export var room_zoom : Vector2 = Vector2(0.7, 0.7)
var initial_zoom : Vector2

func _ready() -> void:
	camera_trigger = $CameraTrigger
	viewport_camera = get_viewport().get_camera_2d()	# Player Camera2D
	initial_zoom = viewport_camera.zoom
	
func _process(delta: float) -> void:
	if visited :
		viewport_camera.zoom = lerp(viewport_camera.zoom, room_zoom, zooming_speed)
	else :
		viewport_camera.zoom = lerp(viewport_camera.zoom, initial_zoom, zooming_speed)
	
func _on_body_entered(body: Node2D) -> void: 
	if body.name == "Protagonist":
		direction_sign_on_entered = body.global_position.direction_to(camera_trigger.global_position).sign()
		if !visited:
			print("Player entered the room")
			visited = true
		else:
			print("Player exited the room")
			visited = false	

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Protagonist":
		var direction_sign = body.global_position.direction_to(camera_trigger.global_position).sign()
		if (horizontal_entrance_check(direction_sign) || vertical_entrance_check(direction_sign)): 
			return
		visited = !visited

func horizontal_entrance_check(direction_sign : Vector2) -> bool:
	return rotation == deg_to_rad(0) && direction_sign.x != direction_sign_on_entered.x
	
func vertical_entrance_check(direction_sign : Vector2) -> bool:
	return rotation == deg_to_rad(90) && direction_sign.y != direction_sign_on_entered.y
