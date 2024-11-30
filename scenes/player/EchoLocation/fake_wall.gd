extends TileMapLayer

var touched_wall = false;
var time_elapsed_since_hit = 0
@export var max_blink_duration_seconds = 2
@export var blink_speed_modifier = 10


func on_echo_hit():
	print_debug("Fake Wall Hit")
	self.tile_set.set_occlusion_layer_light_mask(0, 2)
	# 	make tilemap layer glow
	touched_wall = true

func _process(delta: float) -> void:
	# modulate alpha over time in and out
	if touched_wall:
		self.modulate.a = sin(time_elapsed_since_hit * blink_speed_modifier) + 1
		time_elapsed_since_hit += delta
	
		if time_elapsed_since_hit > max_blink_duration_seconds:
			touched_wall = false
			time_elapsed_since_hit = 0
			self.modulate.a = 1
	
