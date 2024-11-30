extends Node2D

@onready var correct_torches: Array[MazeTorch] = [
	$Torches/Torch,
	$Torches/Torch4,
	$Torches/Torch6,
	$Torches/Torch7
]

@onready var wrong_torches: Array[MazeTorch] = [
	$Torches/Torch2,
	$Torches/Torch3,
	$Torches/Torch5
]

@onready var door: Door = $Door

func _is_solved() -> bool:
	for torch in correct_torches:
		if !torch.light.enabled:
			return false
	for torch in wrong_torches:
		if torch.light.enabled:
			return false
	return true


func _process(delta: float) -> void:
	if _is_solved():
		door._open_door()
		set_process(false)
		return
	
