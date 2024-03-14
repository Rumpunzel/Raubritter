class_name CharacterController
extends CharacterBody2D

@export var _movement_speed := 128.0
@export var _turn_speed := 16.0
@export_enum("Up", "Down", "Left", "Right") var _look_direction: int

var is_on_path := false
var destination: Vector2 :
	get: return _navgiation_agent.target_position
	set(new_destination): _navgiation_agent.target_position = new_destination

var _look_vector: Vector2

@onready var _navgiation_agent: NavigationAgent2D = $NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match _look_direction:
		0:
			_look_vector = Vector2.UP
		1:
			_look_vector = Vector2.DOWN
		2:
			_look_vector = Vector2.LEFT
		3:
			_look_vector = Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if _navgiation_agent.is_navigation_finished(): return
	var next_path_position := _navgiation_agent.get_next_path_position()
	var motion := next_path_position - global_position
	var movement_speed := _movement_speed * (1.25 if is_on_path else 1.0)
	move_and_collide(motion.normalized() * movement_speed * delta)
	rotation = lerp_angle(rotation, _look_vector.angle_to(motion), _turn_speed * delta)
