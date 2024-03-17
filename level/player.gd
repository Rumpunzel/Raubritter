extends Node

signal gold_changed(gold: int)

@export var _gold := 10 :
	set(new_gold):
		_gold = new_gold
		gold_changed.emit(_gold)

@export var _unit: Outlaw
@export var _thug_spawner: UnitSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gold_changed.emit(_gold)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Input.is_action_just_pressed("debug_spawn_thug"): return
	if _unit.can_spawn_unit(_gold):
		_gold -= _unit.cost
		_thug_spawner.spawn_unit_at(get_viewport().get_mouse_position(), _unit)

func _on_coin_spawned(coin: Coin) -> void:
	coin.collected.connect(_on_coin_collected)

func _on_coin_collected(coin_value: int) -> void:
	_gold += coin_value
