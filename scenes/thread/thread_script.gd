extends Node2D

@export var tracked : Node2D
var line : Line2D
var area_2d : Area2D
var collision_shape : CollisionShape2D

@export var create_point_treshold : float = 1000.0
@export var collision_shape_x : float = 2.5
@export var collision_shape_y : float = 2.5
@export var offset : float = 0.25

var enabled : bool = false

func _ready() -> void:
	# initialize the line with two point. The start will be fixed; the end will follow the tracked object
	line = $Line2D
	area_2d = $Area2D
	collision_shape = $Area2D/CollisionShape2D
	line.points = [self.position, tracked.position]

func _process(delta: float) -> void:
	var tracked_curr_pos = tracked.position
	line.set_point_position(line.get_point_count() - 1, tracked_curr_pos)
	# Draw or erase part of the thread
	if tracked_curr_pos.distance_to(line.points[line.get_point_count() - 2]) > create_point_treshold:
		add_point(tracked_curr_pos)

func add_point(current_position : Vector2):
	line.add_point(current_position, line.get_point_count() - 1)
	place_area()

func place_area():
	if(line.get_point_count() < 3) : return
	var p1 = line.points[-3]
	var p2 = line.points[-2]
	var direction = p1.direction_to(p2)
	collision_shape.position = (p2 - p1) * offset + p1
	collision_shape.rotation = direction.angle()
	
func _on_area_2d_body_entered(body:Node2D):
	if enabled && body == tracked:
		line.remove_point(line.get_point_count() - 2)
		place_area()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if !enabled && body == tracked:
		enabled = true
		
