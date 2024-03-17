class_name SpawnPoints
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_random_spawn_point() -> SpawnPoint:
	return get_children().pick_random()

func get_random_route(start: SpawnPoint) -> SpawnPoint:
	var spawn_points := get_children()
	spawn_points.erase(start)
	return spawn_points.pick_random()
