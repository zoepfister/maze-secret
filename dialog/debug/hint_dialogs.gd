extends Node

@onready var player: Node2D = self.get_parent()

var position: Vector2

var lines: Array[String] = [
	"Mmh, weird...",
	"I already saw this wall"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("simulate_hint"):
		DialogManager.start_dialog(player, lines)
