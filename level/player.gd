extends Node

@export var _gold := 10 :
	set(new_gold):
		_gold = new_gold
		_gui.update_gold(_gold)

@export var _unit: Outlaw
@export var _thug_spawner: UnitSpawner
@export var _gui: GUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("debug_spawn_thug"): return
	if _unit.can_spawn_unit(_gold):
		_gold -= _unit.cost
		_thug_spawner.spawn_unit_at(get_viewport().get_mouse_position(), _unit)
