extends Node2D

var camera_trigger : CollisionShape2D
var direction_sign_on_entered : Vector2
var visited : bool = false
var viewport_camera : Camera2D
@export var zooming_factor : float = 0.5

func _ready() -> void:
	camera_trigger = $Area2D/CameraTrigger
	viewport_camera = get_viewport().get_camera_2d()	# Player Camera2D
	
func _process(delta: float) -> void:
	if visited :
		viewport_camera.zoom.x = lerp(viewport_camera.zoom.x, 0.75, zooming_factor)
		viewport_camera.zoom.y = lerp(viewport_camera.zoom.y, 0.75, zooming_factor)
	else :
		viewport_camera.zoom.x = lerp(viewport_camera.zoom.x, 1.2, zooming_factor)
		viewport_camera.zoom.y = lerp(viewport_camera.zoom.y, 1.2, zooming_factor)
	
func _on_area_2d_body_entered(body: Node2D) -> void: 
	if body.name == "Protagonist":
		direction_sign_on_entered = body.global_position.direction_to(camera_trigger.global_position).sign()
		if !visited:
			print("Player entered the room")
			visited = true
		else:
			print("Player exited the room")
			visited = false	

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Protagonist":
		var direction_sign = body.global_position.direction_to(camera_trigger.global_position).sign()
		# If the player enter the trigger from one side and exit it from the other,
		# the direction.x component should change sign (horizontal entrance)
		if direction_sign.x != direction_sign_on_entered.x:
			return
		visited = !visited
