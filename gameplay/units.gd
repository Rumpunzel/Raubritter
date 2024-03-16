class_name Units
extends Node

@export var _hud: HUD

func _enter_tree() -> void:
	for unit_instance: UnitInstance in get_children():
		unit_instance.healthbar_requested.connect(_hud.create_healthbar)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
