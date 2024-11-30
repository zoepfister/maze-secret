extends Node2D

@onready var door: Door = $Door
@onready var interaction_area: InteractionArea = $Door/InteractionArea

func _ready() -> void:
	interaction_area.action_name = "open"
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact() -> void:
	if door.is_open:
		door._close_door()
		interaction_area.action_name = "open"
	else:
		door._open_door()
		interaction_area.action_name = "close"
