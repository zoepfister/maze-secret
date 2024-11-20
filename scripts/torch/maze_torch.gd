extends AnimatedSprite2D

var animation_name : String = "default"
var light : PointLight2D
var trigger : Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# By default, torch light is disabled
	light = $TorchLight
	light.enabled = false
	
	trigger = $TriggerArea

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	play(animation_name)

func enable_light() -> void:
	light.enabled = true
	animation_name = "light_up"

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if !light.enabled && body.name == "Protagonist":
		if body.get_has_torch():
			enable_light()
