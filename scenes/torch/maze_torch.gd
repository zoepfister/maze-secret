extends AnimatedSprite2D
class_name MazeTorch

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var light : PointLight2D = $TorchLight

signal lit_up(torch: MazeTorch)
signal blown_off(torch: MazeTorch)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# By default, torch light is disabled
	light.enabled = false
	animation = "default"
	interaction_area.interact = Callable(self, "_on_interact")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	play()

func _light_up_torch() -> void:
	light.enabled = true
	animation = "light_up"
	interaction_area.action_name = "Blow off"
	lit_up.emit(self)
	
func _blow_off_torch():
	light.enabled = false
	animation = "default"
	interaction_area.action_name = "Light up"
	blown_off.emit(self)
	
func _on_interact() -> void:
	if !light.enabled:
		if player.has_torch:
			_light_up_torch()
		else:
			DialogManager.start_dialog(player, ["I don't have anything for that..."])
	else:
		_blow_off_torch()
