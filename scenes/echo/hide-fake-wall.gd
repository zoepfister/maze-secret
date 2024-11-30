extends Area2D

@export var selectedFakeWallLayer: TileMapLayer

func _on_body_entered(body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(selectedFakeWallLayer, "modulate:a", 0.0, .5)
	selectedFakeWallLayer.set_process(false)
