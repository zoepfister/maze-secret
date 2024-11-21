extends AnimatedSprite2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player: Player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	play("default")
	
func _on_interact():
	player.has_torch = true
	queue_free()
