class_name PathExits
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_random_exit() -> PathExit:
	return get_children().pick_random()

func get_random_destination(start: PathExit) -> PathExit:
	var path_exits := get_children()
	path_exits.erase(start)
	return path_exits.pick_random()
