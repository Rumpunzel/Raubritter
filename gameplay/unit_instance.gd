class_name UnitInstance
extends Node

signal hit_points_changed(hit_points: float)
signal hit_point_segment_changed(hit_point_segment: int)

signal coin_dropped(dropped_from: Vector2)

var unit: Unit
var destination: Node2D

var _hit_points: float :
	set(new_hit_points):
		_hit_points = new_hit_points
		hit_points_changed.emit(_hit_points)
		if _hit_points <= 0.0: _die()

var _character_controller: CharacterController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hit_points = unit.hit_points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not _character_controller: return
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
	var old_hit_points := _hit_points
	_hit_points -= damage_taken
	if get_hit_point_segment() != get_hit_point_segment(old_hit_points):
		_on_hit_point_segment_changed()
	_character_controller.knockback(source.get_position(), weapon.recoil, false)

func get_hit_point_segment(hit_points_to_check := _hit_points) -> int:
	return floori(hit_points_to_check / Unit.HIT_POINT_SEGMENT_SIZE)

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
	var position := get_position()
	for _i: int in range(unit.bounty.coins_for_kill):
		coin_dropped.emit(position)
	if _character_controller: _character_controller.queue_free()
	#queue_free()

func _on_hit_point_segment_changed() -> void:
	hit_point_segment_changed.emit(get_hit_point_segment())
	var position := get_position()
	for _i: int in range(unit.bounty.coins_for_segment):
		coin_dropped.emit(position)

# Called from signal emitted by [WeaponInstance]
func _on_attacked(weapon: Weapon, _weapon_instance: WeaponInstance, hit_box: HitBox) -> void:
	hit_box.damage(weapon.damage, self, weapon)
