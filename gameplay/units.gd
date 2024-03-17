class_name UnitSpawner
extends Node

@export var _hud: HUD
@export var _path_exits: PathExits

@export var _unit: Unit
@export var _thug: Unit

func _ready() -> void:
	_on_spawn_timer_timeout()

func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("debug_spawn_thug"): return
	var thug := _thug.create_unit_instance()
	add_child(thug)
	thug.spawn_at(get_viewport().get_mouse_position())
	_hud.create_healthbar(thug)

func _on_spawn_timer_timeout() -> void:
	var unit := _unit.create_unit_instance()
	add_child(unit)
	var spawn_point := _path_exits.get_random_exit()
	unit.spawn(spawn_point)
	unit.destination = _path_exits.get_random_destination(spawn_point)
	_hud.create_healthbar(unit)
