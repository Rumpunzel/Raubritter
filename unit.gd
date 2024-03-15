extends Node

@export var _unit: CharacterController
@export var _healthbar_offset := 48.0
@export var _cart: CharacterController

@onready var _healthbars: Control = $Healthbars

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_unit.destination = _unit.get_global_mouse_position()
	else:
		_unit.destination = _cart.global_position
	_healthbars.global_position = _unit.global_position + Vector2(0.0, -_healthbar_offset) - _healthbars.size * 0.5
