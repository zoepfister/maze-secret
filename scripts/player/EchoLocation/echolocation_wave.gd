extends Area2D

var radius = 0
var touched_wall = false;
@export var alpha = .8
@export var arc_color = Color(0.5, 0.8, 1.0, alpha)
@export var fade_out_speed = .5


func _ready():
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	collision_shape.position = Vector2.ZERO;
	collision_shape.shape = circle_shape
	add_child(collision_shape)
	body_entered.connect(_on_body_entered)

func _draw():
	# Draw main arc
	arc_color.a = alpha
	draw_arc(Vector2.ZERO, radius, 0, 4*PI, 32, arc_color, 3.0)
	draw_arc(Vector2.ZERO, radius + 10, 0, 4*PI, 32, arc_color, 3.0)
	draw_arc(Vector2.ZERO, radius + 20, 0, 4*PI, 32, arc_color, 3.0)

func _physics_process(_delta):
	$CollisionShape2D.shape.radius = radius + 20
	queue_redraw()

func _process(delta: float) -> void:
# 	gradually hide the circle (will get cleared by parent when below 0)
	if touched_wall:
		alpha -= fade_out_speed * delta

func _on_body_entered(_body):
	touched_wall = true;
	return 
	
