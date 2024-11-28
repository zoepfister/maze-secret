extends AnimatedSprite2D

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@export var opener: Node2D

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape.disabled = false
	opener.solved.connect(_on_solved)

func _on_solved():
	_open_door()

func _open_door():
	play("opening")
	collision_shape.disabled = true
	is_open = true
	
func _close_door():
	play_backwards("opening")
	collision_shape.disabled = false
	is_open = false
	
