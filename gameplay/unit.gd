class_name Unit
extends Resource

@export_placeholder("Name") var name: String
@export var color: Color
@export var hit_points := 100.0
@export var health_bar_girth := 8.0

@export var mass := 75.0
@export var movement_speed := 64.0
@export var acceleration := 16.0
@export var drag := 8.0
@export var turn_speed := 8.0

@export var _scene: PackedScene

func create_unit_instance() -> UnitInstance:
	return null

func create_character_controller() -> CharacterController:
	return _scene.instantiate() as CharacterController
