extends Area2D

@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var player: Player = get_tree().get_first_node_in_group("player")

var direction_on_entered: Vector2
var direction_on_exited: Vector2
var ELEVATED_AREA_Z_INDEX = 1

func _on_body_entered(body: Node2D) -> void:
	direction_on_entered = body.global_position.direction_to(shape.global_position).sign()
	if _is_player_on_elevated_area():
		_exit_elevated_map()
	else:
		_enter_eleveted_map()

func _on_body_exited(body: Node2D) -> void:
	direction_on_exited = body.global_position.direction_to(shape.global_position).sign()
	if (direction_on_entered.y != direction_on_exited.y): return
	if _is_player_on_elevated_area():
		_exit_elevated_map()
	else:
		_enter_eleveted_map()

func _enter_eleveted_map() -> void:
	player.z_index += 1
	player.set_collision_layer_value(7, true)
	player.set_collision_mask_value(7, true)
	player.set_collision_layer_value(2, false)
	player.set_collision_mask_value(2, false)
	
func _exit_elevated_map() -> void:
	player.z_index -= 1
	player.set_collision_layer_value(7, false)
	player.set_collision_mask_value(7, false)
	player.set_collision_layer_value(2, true)
	player.set_collision_mask_value(2, true)
	
func _is_player_on_elevated_area() -> bool:
	return player.z_index == ELEVATED_AREA_Z_INDEX
