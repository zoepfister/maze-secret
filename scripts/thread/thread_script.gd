extends Node2D

@export var tracked_object : Node2D
@export var track : Line2D
@export var minimum_distance_for_update : float = 7.0
@export var minimum_distance_for_trigger : float = 55.0
var previous_position : Vector2
var vertical_epsilon : float = 25.0
var horizontal_epsilon : float = 10.0
@export var backtrack_vertical_offset : float = 10
var backtrack_trigger : RectangleShape2D
var trigger_point : Vector2
@export var collision_shape : CollisionShape2D
var is_trigger_active : bool = false
var is_backtracking : bool = false
var backtrack_direction : Vector2
var angle_treshold: float = deg_to_rad(25)

func _ready() -> void:
	print("Global: ", tracked_object.global_position, "\nPosition: ", tracked_object.position)
	previous_position = tracked_object.position
	track.points =  [previous_position, previous_position]	# To update immidiately the second point
	backtrack_trigger = collision_shape.shape

func _process(delta: float) -> void:
	var new_position = tracked_object.position
	if !enough_distance_covered(new_position) || is_backtracking: return 
	if linear_movement(new_position): return track_linear_movement(new_position)
	track_movement(new_position)
	
func enough_distance_covered(tracked_curr_pos : Vector2) -> bool:
	return (abs(tracked_curr_pos.x - previous_position.x) > minimum_distance_for_update ||
	 abs(tracked_curr_pos.y - previous_position.y) > minimum_distance_for_update)

func linear_movement(tracked_curr_pos : Vector2) -> bool:
	return is_horizontal_movement(tracked_curr_pos.y) || is_vertical_movement(tracked_curr_pos.x)
	
func is_horizontal_movement(tracked_curr_pos_y : float) -> bool:
	return abs(tracked_curr_pos_y - previous_position.y) < vertical_epsilon

func is_vertical_movement(tracked_curr_pos_x : float) -> bool:
	return abs(tracked_curr_pos_x - previous_position.x) < horizontal_epsilon
	
func backtrack() -> void:
	track.remove_point(track.get_point_count() - 1)
	set_backtrack_trigger()
	if deviation_from_backtrack_direction() > angle_treshold:
		is_backtracking = false

func set_backtrack_trigger() -> void:
	if(track.get_point_count() < 3) : return
	var p1 = track.points[-3]
	var p2 = track.points[-2]
	var distance = p1.distance_to(p2)
	backtrack_trigger.size.x = distance
	backtrack_trigger.size.y = backtrack_vertical_offset
	collision_shape.position = Vector2((p1.x + p2.x)*0.5, (p1.y + p2.y)*0.5)
	backtrack_direction = p1.direction_to(p2)
	collision_shape.rotation = backtrack_direction.angle()
	trigger_point = p2

func deviation_from_backtrack_direction() -> float:
	return abs(tracked_object.position.direction_to(trigger_point).angle_to(backtrack_direction)) 

func track_linear_movement(new_point : Vector2) -> void : 
	track.set_point_position(track.get_point_count() -1 , new_point)
	
func track_movement(new_point : Vector2) -> void :
	track.add_point(new_point)
	set_backtrack_trigger()
	is_trigger_active = false
	previous_position = new_point

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_trigger_active && body == tracked_object:
		print("Player triggered:\n\tplayer position: ", tracked_object.position, "\n\tlast point: ", trigger_point, "\n\tprevious position: ", previous_position)
		is_backtracking = true
		backtrack()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if !is_trigger_active && body == tracked_object:
		is_trigger_active = true
