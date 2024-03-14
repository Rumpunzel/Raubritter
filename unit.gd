extends Node

@export var _unit: CharacterController
@export var _healthbar_offset := 48.0

@onready var _healthbars: Control = $Healthbars

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_unit.destination = _unit.get_global_mouse_position()
	_healthbars.global_position = _unit.global_position + Vector2(0.0, -_healthbar_offset) - _healthbars.size * 0.5
