extends AnimatedSprite2D

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var light : PointLight2D = $TorchLight

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
	
func _blow_off_torch():
	light.enabled = false
	animation = "default"
	
func _on_interact(body: Node2D) -> void:
	if !light.enabled:
		if player.has_torch:
			_light_up_torch()
			interaction_area.action_name = "Blow off"
	else:
		_blow_off_torch()
		interaction_area.action_name = "Light up"
