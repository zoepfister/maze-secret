extends Area2D

var radius = 0
var max_reflections = 1
var reflection_count = 0
var original_direction = Vector2.ZERO
var direction = Vector2.ZERO
var speed = Vector2(100, 100)

# get player by name
#@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	collision_shape.position = Vector2.ZERO;
	collision_shape.shape = circle_shape
	add_child(collision_shape)
	body_entered.connect(_on_body_entered)

func _draw():
	#draw_circle(Vector2.ZERO, radius, Color(0.5, 0.8, 1.0, 0.3))
	draw_arc(Vector2.ZERO, radius, 0, 2 * PI, 32, Color(0.5, 0.8, 1.0, 0.5), 2.0)

func _physics_process(_delta):
	queue_redraw()
	$CollisionShape2D.shape.radius = radius

func _on_body_entered(body):
	#if body.is_in_group("walls"):
	if reflection_count < max_reflections:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(
			position - speed.normalized() * 10,
			position + speed.normalized() * 10,
			collision_mask
		)
		var result = space_state.intersect_ray(query)
		
		if result:
			speed = speed.bounce(result.normal)
			reflection_count += 1
	if body.has_method("on_echo_hit"):
		body.on_echo_hit()
