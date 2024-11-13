extends Node2D

@export var trackedObject : Node2D
@export var track : Line2D
@export var minimumDistanceForUpdate : float = 5.0
@export var initialOffest : Vector2 = Vector2(50,100)
var previousPosition : Vector2
var verticalEpsilon : float = 25.0
var horizontalEpsilon : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previousPosition = Vector2(trackedObject.global_position.x, trackedObject.global_position.y)
	var startingPoint = previousPosition + initialOffest
	track.points =  [startingPoint, startingPoint]	# To update immidiately the second point


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var newPosition : Vector2 = Vector2(trackedObject.global_position.x, trackedObject.global_position.y)
	if !enoughDistanceCovered(newPosition): return 
	if linearMovement(newPosition): return trackLinearMovement(newPosition)
	trackMovement(newPosition)# Debug: check size of points
	
func enoughDistanceCovered(trackedObjectCurrentPosition : Vector2) -> bool:
	return (abs(trackedObjectCurrentPosition.x - previousPosition.x) > minimumDistanceForUpdate ||
	 abs(trackedObjectCurrentPosition.y - previousPosition.y) > minimumDistanceForUpdate)

func linearMovement(trackedObjectCurrentPosition : Vector2) -> bool:
	return horizontalMovement(trackedObjectCurrentPosition.y) || verticalMovement(trackedObjectCurrentPosition.x)
	
func horizontalMovement(trackedObjectCurrentPositionY : float) -> bool:
	return abs(trackedObjectCurrentPositionY - previousPosition.y) < verticalEpsilon

func verticalMovement(trackedObjectCurrentPositionX : float) -> bool:
	return abs(trackedObjectCurrentPositionX - previousPosition.x) < horizontalEpsilon
	
func trackLinearMovement(newPoint : Vector2) -> void : 
	track.set_point_position(track.get_point_count() -1 , newPoint + initialOffest)
	
func trackMovement(newPoint : Vector2) -> void :
	track.add_point(newPoint + initialOffest)
	previousPosition = newPoint
	print(track.get_point_count())		# Debug: check size of points
