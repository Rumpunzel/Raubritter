class_name UnitInstance
extends Node

signal hit_points_changed(hit_points: float)
signal hit_point_segment_changed(hit_point_segment: int)

@export var hit_point_segment_size := 25.0

var unit: Unit
var destination: Node2D

var hit_points: float :
	set(new_hit_points):
		var old_hit_points := hit_points
		hit_points = new_hit_points
		if get_hit_point_segment() != get_hit_point_segment(old_hit_points):
			hit_point_segment_changed.emit(get_hit_point_segment())
		hit_points_changed.emit(hit_points)

var _character_controller: CharacterController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_points = unit.hit_points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		_character_controller.destination = get_viewport().get_mouse_position()
		return
	if not destination:
		var carts := get_tree().get_nodes_in_group("Cart")
		for cart: CharacterController in carts:
			var distance_to_cart := _character_controller.global_position.distance_squared_to(cart.global_position)
			if not destination or distance_to_cart < _character_controller.global_position.distance_squared_to(destination.global_position):
				destination = cart
		if not destination: return
	_character_controller.destination = destination.global_position

func damage(damage_taken: float, source: UnitInstance, weapon: Weapon) -> void:
	hit_points -= damage_taken
	if hit_points <= 0.0: _die()
	_character_controller.knockback(source.get_position(), weapon.recoil, false)

func get_hit_point_segment(hit_points_to_check := hit_points) -> int:
	return floori(hit_points_to_check / hit_point_segment_size)

func spawn(spawn_point: Node2D) -> void:
	spawn_at(spawn_point.global_position)
	_character_controller.rotation = spawn_point.rotation

func spawn_at(spawn_position: Vector2) -> void:
	_character_controller = unit.create_character_controller()
	add_child(_character_controller)
	_character_controller.global_position = spawn_position
	_character_controller.connect_to_unit_instance(self)

func get_position() -> Vector2:
	return _character_controller.global_position

func get_healthbar_position() -> Vector2:
	if not _character_controller: return Vector2.ZERO
	var in_world_position := _character_controller.global_position - Vector2(0.0, _character_controller.health_bar_offset)
	return _character_controller.get_viewport_transform() * in_world_position

func _die() -> void:
	if _character_controller: _character_controller.queue_free()
	queue_free()

# Called from signal emitted by [WeaponInstance]
func _on_attacked(weapon: Weapon, _weapon_instance: WeaponInstance, hit_box: HitBox) -> void:
	hit_box.damage(weapon.damage, self, weapon)
