extends Area2D

@export var door: Door

func _on_body_entered(body: Node2D) -> void:
	door._close_door()
	set_deferred("monitoring", false)
