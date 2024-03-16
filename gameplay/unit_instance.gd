class_name UnitInstance
extends Node

@export var unit: Unit

@export var _spawn: Node2D
@export var _destination: Node

var hit_points: float :
	set(new_hit_points):
		hit_points = new_hit_points
		_healthbar.update_hit_points(hit_points)
var global_position: Vector2 :
	get: return _character_controller.global_position

@export var _healthbar: Healthbar

var _character_controller: CharacterController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_points = unit.hit_points
	_character_controller = unit.create_character_controller()
	add_child(_character_controller)
	_character_controller.global_position = _spawn.global_position
	_character_controller.rotation = _spawn.rotation
	_character_controller.connect_to_unit_instance(self)
	_healthbar.update_max_hit_points(unit.hit_points)
	_healthbar.custom_minimum_size.y = unit.health_bar_girth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_character_controller.destination = _character_controller.get_global_mouse_position()
	else:
		_character_controller.destination = _destination.global_position
	_healthbar.update_position(_character_controller)

func damage(damage_taken: float, source: UnitInstance, weapon: WeaponInstance) -> void:
	hit_points -= damage_taken
	print("took %f damage!" % damage_taken)

# Called from signal emitted by [WeaponInstance]
func _on_attacked(weapon: Weapon, weapon_instance: WeaponInstance, hit_box: HitBox) -> void:
	hit_box.damage(weapon.damage, self, weapon_instance)
