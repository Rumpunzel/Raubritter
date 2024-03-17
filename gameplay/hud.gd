class_name HUD
extends CanvasLayer

@export var _healthbar: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called via signal from spawner nodes
func _on_unit_spawned(unit_instance: UnitInstance) -> void:
	var healthbar := _healthbar.instantiate() as Healthbar
	add_child(healthbar)
	healthbar.unit_instance = unit_instance
