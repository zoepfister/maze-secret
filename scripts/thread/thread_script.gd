extends Node2D

@export var tracked_object : Node2D
@export var track : Line2D
@export var minimum_distance_for_update : float = 7.0
@export var minimum_distance_for_trigger : float = 55.0
@export var initial_offest : Vector2 = Vector2(50,100)
var previous_position : Vector2
var vertical_epsilon : float = 25.0
var horizontal_epsilon : float = 10.0
@export var backtrack_vertical_offset : float = 10
var backtrack_trigger : RectangleShape2D
var trigger_point : Vector2
@export var collision_shape : CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_position = Vector2(tracked_object.global_position.x, tracked_object.global_position.y)
	var starting_point = previous_position + initial_offest
	track.points =  [starting_point, starting_point, starting_point]	# To update immidiately the second point
	backtrack_trigger = collision_shape.shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#track.set_point_position(track.get_point_count() - 1, tracked_object.position)
	var new_position : Vector2 = Vector2(tracked_object.global_position.x, tracked_object.global_position.y)
	if !enoughDistanceCovered(new_position): return 
	if linearMovement(new_position): return trackLinearMovement(new_position)
	trackMovement(new_position)# Debug: check size of points
	
func enoughDistanceCovered(tracked_curr_pos : Vector2) -> bool:
	return (abs(tracked_curr_pos.x - previous_position.x) > minimum_distance_for_update ||
	 abs(tracked_curr_pos.y - previous_position.y) > minimum_distance_for_update)

func linearMovement(tracked_curr_pos : Vector2) -> bool:
	return horizontalMovement(tracked_curr_pos.y) || verticalMovement(tracked_curr_pos.x)
	
func horizontalMovement(tracked_curr_pos_y : float) -> bool:
	return abs(tracked_curr_pos_y - previous_position.y) < vertical_epsilon

func verticalMovement(tracked_curr_pos_x : float) -> bool:
	return abs(tracked_curr_pos_x - previous_position.x) < horizontal_epsilon
	
func backtrack() -> void:
	track.remove_point(track.get_point_count() - 1)
	if (track.get_point_count() > 3):
		set_backtrack_trigger(track.points[-3], track.points[-2])

func set_backtrack_trigger(p1 : Vector2, p2 : Vector2) -> void:
	var distance = p1.distance_to(p2)
	backtrack_trigger.size.x = distance
	backtrack_trigger.size.y = backtrack_vertical_offset
	collision_shape.position = Vector2((p1.x + p2.x)*0.5, (p1.y + p2.y)*0.5)
	collision_shape.rotation = p1.direction_to(p2).angle()
	trigger_point = p2

func trackLinearMovement(new_point : Vector2) -> void : 
	track.set_point_position(track.get_point_count() -1 , new_point + initial_offest)
	set_backtrack_trigger(track.points[-3], track.points[-2])
	
func trackMovement(new_point : Vector2) -> void :
	track.add_point(new_point + initial_offest)
	set_backtrack_trigger(track.points[-3], track.points[-2])
	previous_position = new_point
	print(track.get_point_count())		# Debug: check size of points


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body == tracked_object && 
		abs(previous_position.x - trigger_point.x) > minimum_distance_for_trigger &&
		 abs(previous_position.y - trigger_point.y) > minimum_distance_for_trigger):
		print("Player triggered:\n\tplayer position: ", tracked_object.position, "\n\tlast point: ", trigger_point, "\n\tprevious position: ", previous_position)
		backtrack()
