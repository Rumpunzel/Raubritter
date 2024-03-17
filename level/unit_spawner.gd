class_name UnitSpawner
extends Node

signal unit_spawned(unit_instance: UnitInstance)

@export var _unit: Unit
@export var _spawn_parent: Node = self
@export var _spawn_points: SpawnPoints

func spawn_unit_at(spawn_position: Vector2, unit := _unit) -> UnitInstance:
	var unit_instance := _create_unit(unit)
	unit_instance.spawn_at(spawn_position)
	return unit_instance

func spawn_unit(spawn_point := _spawn_points.get_random_spawn_point(), unit := _unit) -> UnitInstance:
	var unit_instance := _create_unit(unit)
	unit_instance.spawn(spawn_point)
	return unit_instance

func spawn_unit_on_route(
	spawn_point := _spawn_points.get_random_spawn_point(),
	destination := _spawn_points.get_random_route(spawn_point),
	unit := _unit,
) -> UnitInstance:
	var unit_instance := spawn_unit(spawn_point, unit)
	unit_instance.destination = destination
	return unit_instance

func _create_unit(unit: Unit) -> UnitInstance:
	assert(unit != null, "Cannot create null unit!")
	var unit_instance := unit.create_unit_instance()
	var parent: Node = _spawn_parent if _spawn_parent else self
	parent.add_child(unit_instance)
	unit_spawned.emit(unit_instance)
	return unit_instance
