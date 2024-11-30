extends AnimatedSprite2D
class_name Door

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var is_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_open:
		animation = "opening"
		frame = 6
		collision_shape.disabled = true
	else:
		animation = "default"
		collision_shape.disabled = false

func _open_door():
	play("opening")
	collision_shape.disabled = true
	is_open = true
	
func _close_door():
	play_backwards("opening")
	collision_shape.set_deferred("disabled", false)
	is_open = false
	
