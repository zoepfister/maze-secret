extends MarginContainer
class_name TextBox

@onready var label = $Text/Label
@onready var timer: Timer = $CharDisplayTimer

@export_group("TextBox settings")
@export var max_width: int = 256
@export var text_speed: float = 0.03
@export var y_offset: float = 40.0
@export var x_offset: float = 24.0
@export_group("")

var text: String = ""
var char_index: int = 0
var tracked_node: Node2D

signal finished_displaying()

#func _ready() -> void:
	#global_position = _get_adjusted_global_position()

func _process(delta: float) -> void:
	global_position = _get_adjusted_global_position()

func _get_adjusted_global_position() -> Vector2:
	var adjusted_position: Vector2 = tracked_node.global_position
	adjusted_position.x += x_offset
	adjusted_position.y -= size.y + y_offset
	
	return adjusted_position

func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display	# calculate label size
	
	await resized					# wait for label to resize

	custom_minimum_size.x = min(size.x, max_width)	
	if size.x > max_width:
		label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
		await resized				# wait for x resize
		await resized				# wait for y resize
	custom_minimum_size.y = size.y
	
	global_position = _get_adjusted_global_position()
	
	label.text = ""					# clear textbox content to display letter by letter
	_display_char()
	
func _display_char():
	label.text += text[char_index]
	char_index += 1
	if char_index >= text.length():
		finished_displaying.emit()
		return
	timer.start(text_speed)

func _on_char_display_timer_timeout() -> void:
	_display_char()
