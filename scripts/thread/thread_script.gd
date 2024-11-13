extends Node2D

@export var trackedObject : Node2D
@export var track : Line2D
@export var minimumDistanceForUpdate : float = 5.0
@export var initialOffest : Vector2 = Vector2(50,100)
var previousPosition : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previousPosition = Vector2(trackedObject.global_position.x, trackedObject.global_position.y)
	var startingPoint = previousPosition + initialOffest
	track.points =  [startingPoint]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var newPosition : Vector2 = Vector2(trackedObject.global_position.x, trackedObject.global_position.y)
	if (abs(newPosition.x - previousPosition.x) > minimumDistanceForUpdate ||
		abs(newPosition.y - previousPosition.y) > minimumDistanceForUpdate) : 
		track.add_point(newPosition + initialOffest)
		previousPosition = newPosition
	print(track.points.size())
