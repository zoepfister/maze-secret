extends AnimatedSprite2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D

var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	collision_shape.disabled = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_interact():
	if !is_open:
		_open_door()
	else:
		_close_door()

func _open_door():
	play("opening")
	interaction_area.action_name = "close"
	collision_shape.disabled = true
	is_open = true
	
func _close_door():
	play_backwards("opening")
	interaction_area.action_name = "open"
	collision_shape.disabled = false
	is_open = false
	
