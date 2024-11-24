extends Node

@onready var text_box_scene = preload("res://dialog/TextBox.tscn")
@onready var timer: Timer = $TextBoxTimer

@export var text_box_lifespan: float = 3.0
@export var text_box_fadeout_seconds = 0.8

var dialog_lines: Array[String] = []
var line_index: int = 0

var text_box: TextBox
var tracked: Node2D
var is_dialog_active = false
var can_advance_line = false

func start_dialog(tracked_node: Node2D, lines: Array[String]):
	if is_dialog_active:
		return
	if lines.size() == 0:
		return
	dialog_lines = lines
	tracked = tracked_node
	
	_show_text_box()
	is_dialog_active = true
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.tracked_node = tracked
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.display_text(dialog_lines[line_index])
	can_advance_line = false
	
func _on_text_box_finished_displaying():
	can_advance_line = true
	timer.start(text_box_lifespan)

func _on_text_box_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(text_box, "modulate:a", 0.0, text_box_fadeout_seconds)
	tween.tween_callback(tween_callback)

# Callback after the text box fade-out animation
func tween_callback():
	text_box.queue_free()
	line_index += 1
	if line_index >= dialog_lines.size():
		is_dialog_active = false
		line_index = 0
		return
	_show_text_box()
