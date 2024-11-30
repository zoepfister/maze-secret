extends Area2D

@onready var player: Player = get_tree().get_first_node_in_group("player")

const win_dialog: Array[String] = [
	"Thanks for playing!"
]

func win() -> void:
	DialogManager.start_dialog(player, win_dialog)
