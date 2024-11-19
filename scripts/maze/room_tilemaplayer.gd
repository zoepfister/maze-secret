@tool
extends Node2D

var TOP_WALL_TILES : Array[Vector2i] = [
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(3,0),
	Vector2i(4,0),
]
var LEFT_WALL_TILES: Array[Vector2i] = [
	Vector2i(0,0),
	Vector2i(0,1),
	Vector2i(0,2),
	Vector2i(0,3),
]
var BOTTOM_WALL_TILES : Array[Vector2i] = [
	Vector2i(1,4),	
	Vector2i(2,4),
	Vector2i(3,4),
	Vector2i(4,4),
]
var RIGHT_WALL_TILES: Array[Vector2i] = [
	Vector2i(5,0),
	Vector2i(5,1),
	Vector2i(5,2),
	Vector2i(5,3),
]
var BOTTOM_LEFT_WALL: Vector2i = Vector2i(0,4)
var BOTTOM_RIGHT_WALL: Vector2i = Vector2i(5,4)

var TOP_LEFT_FLOOR: Vector2i = Vector2i(1,1)
var TOP_RIGHT_FLOOR: Vector2i = Vector2i(4,1)
var BOTTOM_LEFT_FLOOR: Vector2i = Vector2i(1,3)
var BOTTOM_RIGHT_FLOOR: Vector2i = Vector2i(4,3)
var LEFT_FLOOR: Vector2i = Vector2i(1,2)
var RIGHT_FLOOR: Vector2i = Vector2i(4,2)
var TOP_FLOOR_TILES: Array[Vector2i] = [Vector2i(2,1), Vector2i(3,1)] 
var BOTTOM_FLOOR_TILES: Array[Vector2i] = [Vector2i(2,3), Vector2i(3,3)]
var CENTER_FLOOR_TILES : Array[Vector2i] = [
	Vector2i(6,0),
	Vector2i(6,1),
	Vector2i(6,2),
	Vector2i(7,0),
	Vector2i(7,1),
	Vector2i(7,2),
	Vector2i(8,0),
	Vector2i(8,1),
	Vector2i(8,2),
	Vector2i(9,0),
	Vector2i(9,1),
	Vector2i(9,2),
]
@export_group("Room dimensions")
var tile_size : Vector2i
@export var width : int = 10
@export var length : int = 10
@export var wall_height : int = 5 
@export_group("Entrances")
@export var Top : bool
@export var Left : bool
@export var Bottom : bool
@export var Right : bool
@export_group("")
@export var visited : bool
@onready var room_trigger : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_trigger = preload("res://scripts/maze/room_trigger.tscn")
	var tile_map : TileMapLayer = $TileMapLayer
	tile_size = tile_map.tile_set.tile_size
	# Clear before drawing
	tile_map.clear()
	
	draw_floor(tile_map)
	draw_walls(tile_map)
	create_entrances(tile_map)

func draw_walls(tile_map: TileMapLayer) -> void:
	tile_map.set_cell(Vector2i(-1, length), 2, BOTTOM_LEFT_WALL)
	tile_map.set_cell(Vector2i(width, length), 2, BOTTOM_RIGHT_WALL)
	for i in range(0, width + 1):
		for j in range(1, wall_height + 1):
			tile_map.set_cell(Vector2i(i, -j), 2, TOP_WALL_TILES.pick_random())
		tile_map.set_cell(Vector2i(i, length), 2, BOTTOM_WALL_TILES.pick_random())
		
	for i in range(-wall_height, length):
		tile_map.set_cell(Vector2i(-1, i), 2, LEFT_WALL_TILES.pick_random())
		tile_map.set_cell(Vector2i(width, i), 2, RIGHT_WALL_TILES.pick_random())
		
func draw_floor(tile_map: TileMapLayer) -> void:
	# Draw corners
	tile_map.set_cell(Vector2i(0, 0), 2 , TOP_LEFT_FLOOR)
	tile_map.set_cell(Vector2i(width - 1, 0), 2 , TOP_RIGHT_FLOOR)
	tile_map.set_cell(Vector2i(0, length - 1), 2 , BOTTOM_LEFT_FLOOR)
	tile_map.set_cell(Vector2i(width - 1, length - 1), 2 , BOTTOM_RIGHT_FLOOR)
	# Draw top and bottom
	for i in range(1, width - 1):
		tile_map.set_cell(Vector2i(i, 0), 2, TOP_FLOOR_TILES.pick_random())
		tile_map.set_cell(Vector2i(i, length - 1), 2, BOTTOM_FLOOR_TILES.pick_random())
	# Draw laft and right
	for i in range(1, length - 1):
		tile_map.set_cell(Vector2i(0, i), 2, LEFT_FLOOR)
		tile_map.set_cell(Vector2i(width - 1,i), 2, RIGHT_FLOOR)
	# Draw center
	for i in range(1,width - 1):
		for j in range(1, length - 1):
			tile_map.set_cell(Vector2i(i,j), 2, CENTER_FLOOR_TILES.pick_random())

func create_entrances(tile_map : TileMapLayer) -> void:
	if not Engine.is_editor_hint():
		add_trigger()
	if Top:
		for i in range(-2, 2):
			for j in range (1, wall_height + 1):
				tile_map.erase_cell(Vector2i(width * 0.5 + i, -j))
	if Bottom:
		for i in range(-2,2):
			tile_map.erase_cell(Vector2i(width * 0.5 + i, length))
	if Left:
		for i in range(-2,2):
			tile_map.erase_cell(Vector2i(-1, length * 0.5 + i))
	if Right:
		for i in range(-2,2):
			tile_map.erase_cell(Vector2i(width, length * 0.5 + i))
		
func add_trigger():
	var trigger = room_trigger.instantiate()
	add_child(trigger)
	trigger.position = Vector2(width * 0.5 * tile_size.x, length * 0.5 * tile_size.y)
	trigger.set_size(Vector2(width * tile_size.x, length * tile_size.y) * 0.95)
