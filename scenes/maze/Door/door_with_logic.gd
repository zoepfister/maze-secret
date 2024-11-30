extends Door

@export var opener: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_shape.disabled = false
	opener.solved.connect(_on_solved)

func _on_solved():
	_open_door()	
