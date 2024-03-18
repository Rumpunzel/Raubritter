class_name SceneSpawner
extends Node2D

signal node_spawned(node: Node2D)

@export var _scene: PackedScene
@export var _spawn_parent: Node = self
@export var _spawn_points: SpawnPoints

func spawn_node_at(spawn_position: Vector2, scene := _scene) -> Node2D:
	var scene_instance := _create_node(scene) as Node2D
	scene_instance.global_position = spawn_position
	return scene_instance

func spawn_scene(spawn_point := _spawn_points.get_random_spawn_point(), scene := _scene) -> Node2D:
	var scene_instance := spawn_node_at(spawn_point.global_position, scene)
	scene_instance.rotation = spawn_point.rotation
	return scene_instance

func _create_node(scene: PackedScene) -> Node2D:
	assert(scene != null, "Cannot create null scene!")
	var scene_instance := scene.instantiate() as Node2D
	var parent: Node = _spawn_parent if _spawn_parent else self
	parent.add_child.call_deferred(scene_instance)
	node_spawned.emit(scene_instance)
	return scene_instance

func _on_unit_spawned(unit_instance: UnitInstance) -> void:
	unit_instance.coin_dropped.connect(spawn_node_at)
