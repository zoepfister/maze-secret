extends Node2D

@onready var timer: Timer = $SolutionTorchTimer
@onready var cycle_timer: Timer = $Cycle

@export var torch_light_up_timer: float = 1.5
var repeat_cycle_timer

var current_solution_torch: int = 0
var solution_torches: Array[MazeTorch] = []

var player_solution: Array[int]

signal solved

func _ready() -> void:
	solution_torches = [
		$SolutionTorch1,
		$SolutionTorch2,
		$SolutionTorch3,
		$SolutionTorch4
	]
	
	# Register signal for torches
	
	$Torch1.lit_up.connect(_on_lit_up)
	$Torch1.blown_off.connect(_on_blown_off)
	$Torch2.lit_up.connect(_on_lit_up)
	$Torch2.blown_off.connect(_on_blown_off)
	$Torch3.lit_up.connect(_on_lit_up)
	$Torch3.blown_off.connect(_on_blown_off)
	$Torch4.lit_up.connect(_on_lit_up)
	$Torch4.blown_off.connect(_on_blown_off)
	
	repeat_cycle_timer = 3.0 * torch_light_up_timer
	
	_show_torch()

func _show_torch() -> void:
	solution_torches[current_solution_torch]._light_up_torch()
	timer.start(torch_light_up_timer)

func _on_solution_torch_timer_timeout() -> void:
	solution_torches[current_solution_torch]._blow_off_torch()
	current_solution_torch = (current_solution_torch + 1) % solution_torches.size()
	if current_solution_torch == 0:
		cycle_timer.start(repeat_cycle_timer)
	else:
		_show_torch()

func _on_lit_up(torch: MazeTorch):
	print(torch.name)
	var torch_index: int = torch.get_meta("index")
	player_solution.push_back(torch_index)
	if player_solution.size() == 4:
		check_solution()
	
func _on_blown_off(torch: MazeTorch):
	var torch_index: int = torch.get_meta("index")
	var delete_index = player_solution.find(torch_index)
	if delete_index != -1:
		player_solution.remove_at(delete_index)

func check_solution():
	for i in range(0, 3):
		if player_solution[i] > player_solution[i + 1]:
			return
	solved.emit()

func _on_cycle_timeout() -> void:
	_show_torch()
