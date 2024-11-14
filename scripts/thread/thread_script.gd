extends Node2D

@export var tracked_object : Node2D
@export var track : Line2D
@export var minimum_distance_for_update : float = 5.0
@export var initial_offest : Vector2 = Vector2(50,100)
var previous_position : Vector2
var vertical_epsilon : float = 25.0
var horizontal_epsilon : float = 10.0
var backtrack_distance : float = 2.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previous_position = Vector2(tracked_object.global_position.x, tracked_object.global_position.y)
	var starting_point = previous_position + initial_offest
	track.points =  [starting_point, starting_point]	# To update immidiately the second point

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_position : Vector2 = Vector2(tracked_object.global_position.x, tracked_object.global_position.y)
	if trackedObjectIsBacktracking():
		track.remove_point(track.get_point_count() - 1)
		return
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
	
func trackedObjectIsBacktracking() -> bool:
	return (track.get_point_count() > 1 && 
		tracked_object.position.distance_to(track.points[track.get_point_count() - 2]) < backtrack_distance)

func trackLinearMovement(new_point : Vector2) -> void : 
	track.set_point_position(track.get_point_count() -1 , new_point + initial_offest)
	
func trackMovement(new_point : Vector2) -> void :
	track.add_point(new_point + initial_offest)
	previous_position = new_point
	print(track.get_point_count())		# Debug: check size of points
