extends Node

@export var _cart: CharacterController
@export var _healthbar_offset := 48.0
@export var _destination: Area2D

@onready var _healthbars: Control = $Healthbars

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_cart.destination = _destination.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_healthbars.global_position = _cart.global_position + Vector2(0.0, -_healthbar_offset) - _healthbars.size * 0.5
