class_name UnitInstance
extends Node

signal hit_points_changed(hit_points: float)

@export var unit: Unit
@export var destination: Node2D

var hit_points: float :
	set(new_hit_points):
		hit_points = new_hit_points
		hit_points_changed.emit(hit_points)

var _character_controller: CharacterController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_points = unit.hit_points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_character_controller.destination = _character_controller.get_global_mouse_position()
	else:
		if not destination: return
		_character_controller.destination = destination.global_position

func damage(damage_taken: float, _source: UnitInstance, _weapon: WeaponInstance) -> void:
	hit_points -= damage_taken
	print("took %f damage!" % damage_taken)

func spawn(spawn_point: Node2D) -> void:
	_character_controller = unit.create_character_controller()
	add_child(_character_controller)
	_character_controller.global_position = spawn_point.global_position
	_character_controller.rotation = spawn_point.rotation
	_character_controller.connect_to_unit_instance(self)

func get_position() -> Vector2:
	return _character_controller.global_position

func get_healthbar_position() -> Vector2:
	if not _character_controller: return Vector2.ZERO
	var in_world_position := _character_controller.global_position - Vector2(0.0, _character_controller.health_bar_offset)
	return _character_controller.get_viewport_transform() * in_world_position

# Called from signal emitted by [WeaponInstance]
func _on_attacked(weapon: Weapon, weapon_instance: WeaponInstance, hit_box: HitBox) -> void:
	hit_box.damage(weapon.damage, self, weapon_instance)
