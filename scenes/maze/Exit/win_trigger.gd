extends Area2D

@onready var player: Player = get_tree().get_first_node_in_group("player")

const win_dialog: Array[String] = [
	"Thanks for playing!"
]

func win() -> void:
	DialogManager.dialog_finished.connect(_on_dialog_finished)
	DialogManager.start_dialog(player, win_dialog)

func _on_dialog_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/StartMenu.tscn")

func _on_body_entered(body: Node2D) -> void:
	win()
	set_deferred("monitoring", false)	# Deactivate trigger
