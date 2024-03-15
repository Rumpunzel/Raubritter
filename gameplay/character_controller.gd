class_name CharacterController
extends CharacterBody2D

@export var mass := 100.0

@export var _movement_speed := 64.0
@export var _acceleration := 16.0
@export var _drag := 8.0
@export var _turn_speed := 8.0
@export_enum("Up", "Down", "Left", "Right") var _look_direction: int

var is_on_path := false
var destination: Vector2 :
	get: return _navgiation_agent.target_position
	set(new_destination): _navgiation_agent.target_position = new_destination

var _look_vector: Vector2

@onready var _navgiation_agent: NavigationAgent2D = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_navgiation_agent.max_speed = _movement_speed
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
	rotation = lerp_angle(rotation, _look_vector.angle_to(motion), _turn_speed * delta)
	velocity = velocity.lerp(Vector2.ZERO, _drag * delta)
	if not Input.is_key_pressed(KEY_S):
		var movement_speed := _movement_speed * (1.5 if is_on_path else 1.0)
		velocity = velocity.lerp(_get_forward_axis() * movement_speed, _acceleration * delta)
	move_and_slide()

func _get_forward_axis() -> Vector2:
	match _look_direction:
		0: return -transform.y
		1: return transform.y
		2: return -transform.x
		3: return transform.x
	assert(false, "No look direction specified!")
	return Vector2.ZERO

func _on_attack(weapon: Weapon, hit_box: HitBox) -> void:
	velocity = -global_position.direction_to(hit_box.global_position) * pow(weapon.recoil, 2.0)
