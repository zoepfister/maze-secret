extends Line2D

@onready var area_2d : Area2D = $Area2D

@export var tracked : Node2D

@export_group("Backtracking settings")
@export var create_point_treshold : float = 1000.0
@export var collision_shape_x : float = 2.5
@export var collision_shape_y : float = 2.5
@export var offset : float = 0.25

var enabled : bool = false
var collision_shape : CollisionShape2D

func _ready() -> void:
	collision_shape = $Area2D/CollisionShape2D
	# initialize the line with two point. The start will be fixed; the end will follow the tracked object
	points = [tracked.position, tracked.position]

func _process(delta: float) -> void:
	var tracked_curr_pos = tracked.position
	var point_count = get_point_count()
	set_point_position(point_count - 1, tracked_curr_pos)
	# Draw or erase part of the thread
	if tracked_curr_pos.distance_to(points[point_count - 2]) > create_point_treshold:
		_add_point(tracked_curr_pos)

func _add_point(current_position : Vector2):
	add_point(current_position, get_point_count() - 1)
	place_area()

func place_area():
	if(get_point_count() < 3) : return
	var p1 = points[-3]
	var p2 = points[-2]
	var direction = p1.direction_to(p2)
	collision_shape.position = (p2 - p1) * offset + p1
	collision_shape.rotation = direction.angle()
	
func _on_area_2d_body_entered(body:Node2D):
	if enabled && body == tracked:
		_remove_point()
		place_area()

func _remove_point():
	if (get_point_count() > 2):
		remove_point(get_point_count() - 2)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if !enabled && body == tracked:
		enabled = true
		
