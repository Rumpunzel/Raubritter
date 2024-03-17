extends Node

@export var _thug_spawner: UnitSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("debug_spawn_thug"): return
	_thug_spawner.spawn_unit_at(get_viewport().get_mouse_position())
