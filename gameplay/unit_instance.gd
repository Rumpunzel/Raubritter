class_name UnitInstance
extends Node

signal hit_points_changed(hit_points: float)
signal healthbar_requested(unit_instance: UnitInstance)

@export var unit: Unit

@export var _spawn: Node2D
@export var _destination: Node

var hit_points: float :
	set(new_hit_points):
		hit_points = new_hit_points
		hit_points_changed.emit(hit_points)

var _character_controller: CharacterController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_points = unit.hit_points
	_character_controller = unit.create_character_controller()
	add_child(_character_controller)
	_character_controller.global_position = _spawn.global_position
	_character_controller.rotation = _spawn.rotation
	_character_controller.connect_to_unit_instance(self)

func _enter_tree() -> void:
	healthbar_requested.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_character_controller.destination = _character_controller.get_global_mouse_position()
	else:
		pass#_character_controller.destination = _destination.global_position

func damage(damage_taken: float, _source: UnitInstance, _weapon: WeaponInstance) -> void:
	hit_points -= damage_taken
	print("took %f damage!" % damage_taken)

func get_position() -> Vector2:
	return _character_controller.global_position

func get_healthbar_position() -> Vector2:
	var in_world_position := _character_controller.global_position - Vector2(0.0, _character_controller.health_bar_offset)
	return _character_controller.get_viewport_transform() * in_world_position

# Called from signal emitted by [WeaponInstance]
func _on_attacked(weapon: Weapon, weapon_instance: WeaponInstance, hit_box: HitBox) -> void:
	hit_box.damage(weapon.damage, self, weapon_instance)
