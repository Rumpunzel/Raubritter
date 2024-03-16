class_name CharacterController
extends CharacterBody2D

@export var health_bar_offset := 32.0

@export_enum("Up", "Down", "Left", "Right") var _look_direction: int

var unit: Unit :
	set(new_unit):
		unit = new_unit
		_navgiation_agent.max_speed = unit.movement_speed

@export var _navgiation_agent: NavigationAgent2D
@export var _hit_box: HitBox
@export var _weapon: WeaponInstance

var is_on_path := false
var destination: Vector2 :
	get: return _navgiation_agent.target_position
	set(new_destination): _navgiation_agent.target_position = new_destination

var _look_vector: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match _look_direction:
		0: _look_vector = Vector2.UP
		1: _look_vector = Vector2.DOWN
		2: _look_vector = Vector2.LEFT
		3: _look_vector = Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if _navgiation_agent.is_navigation_finished(): return
	var next_path_position := _navgiation_agent.get_next_path_position()
	var motion := next_path_position - global_position
	rotation = lerp_angle(rotation, _look_vector.angle_to(motion), unit.turn_speed * delta)
	velocity = velocity.lerp(Vector2.ZERO, unit.drag * delta)
	if not Input.is_key_pressed(KEY_S):
		var movement_speed := unit.movement_speed * (1.5 if is_on_path else 1.0)
		velocity = velocity.lerp(_get_forward_axis() * movement_speed, unit.acceleration * delta)
	move_and_slide()

func connect_to_unit_instance(unit_instance: UnitInstance) -> void:
	unit = unit_instance.unit
	_hit_box.damaged.connect(unit_instance.damage)
	if _weapon: _weapon.attacked.connect(unit_instance._on_attacked)

func _get_forward_axis() -> Vector2:
	match _look_direction:
		0: return -transform.y
		1: return transform.y
		2: return -transform.x
		3: return transform.x
	assert(false, "No look direction specified!")
	return Vector2.ZERO

# Called from signal emitted by [WeaponInstance]
func _on_attack(weapon: Weapon, _weapon_instance: WeaponInstance, hit_box: HitBox) -> void:
	velocity = -global_position.direction_to(hit_box.global_position) * pow(weapon.recoil, 2.0)
