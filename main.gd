class_name Main
extends Node

signal phase_changed(phase: Phases)

enum Phases {
	BUILD,
	FIGHT,
	CLEANUP,
	REWARD,
}

@export var _round_duration := 30.0

@export var _spawn_timer: Timer
@export var _sun: CanvasModulate
@export var _player: Player
@export var _cart_spawner: UnitSpawner

var _elapsed_time := 0.0
var _state: Phases = Phases.BUILD :
	set(new_state):
		if new_state == _state: return
		_leave_state()
		_state = new_state
		_enter_state()
		phase_changed.emit(_state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_enter_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _state == Phases.BUILD: 
		_player.read_build_inputs()
		if Input.is_action_just_released("continue"):
			_state = Phases.FIGHT
			return
	if _state == Phases.FIGHT or _state == Phases.CLEANUP:
		_elapsed_time += delta
		_sun.time_of_day = Sun.DayTime.DAWN + _elapsed_time / _round_duration * (Sun.DayTime.NOON - Sun.DayTime.DAWN)
	if _state == Phases.FIGHT:
		if _elapsed_time >= _round_duration: _state = Phases.CLEANUP
		# DEBUG!
		if Input.is_action_just_released("continue"):
			_state = Phases.CLEANUP
			return
	if _state == Phases.CLEANUP:
		if get_tree().get_nodes_in_group("Cart").is_empty(): _state = Phases.BUILD
		# DEBUG!
		if Input.is_action_just_released("continue"):
			_state = Phases.BUILD
			return

func _enter_state(state: Phases = _state) -> void:
	if state == Phases.FIGHT:
		_elapsed_time = 0.0
		_on_spawn_timer_timeout()
		_spawn_timer.start()
		_sun.time_of_day = float(Sun.DayTime.DAWN)

func _leave_state(state: Phases = _state) -> void:
	if state == Phases.FIGHT:
		_spawn_timer.stop()
	if state == Phases.CLEANUP:
		var carts := get_tree().get_nodes_in_group("Cart")
		for cart: Node in carts: cart.queue_free()

func _on_spawn_timer_timeout() -> void:
	_cart_spawner.spawn_unit_on_route()
