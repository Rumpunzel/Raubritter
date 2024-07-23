class_name Coin
extends Area2D

signal collected

@export var value := 1

@export var _spawn_radius: Curve
@export var _drop_speed := 128.0

@export var _collision_shape: CollisionShape2D
@export var _animation_player: AnimationPlayer

var _follow: Node2D = null

func _ready() -> void:
	var random_position_on_radius := Vector2(_spawn_radius.sample(randf()), 0.0).rotated(randf() * TAU)
	if _drop_speed <= 0.0:
		position += random_position_on_radius
		return
	var tween := create_tween()
	tween.tween_property(self, "position", random_position_on_radius, random_position_on_radius.length() / _drop_speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).as_relative()

func _process(delta: float) -> void:
	if not _follow: return
	global_position = global_position.lerp(_follow.global_position, delta)
	_animation_player.speed_scale += delta
	if global_position.distance_squared_to(_follow.global_position) <= 16.0:
		_collect()

func collect(collect_to: Node2D) -> void:
	_collision_shape.set_disabled.call_deferred(true)
	if collect_to: _follow = collect_to
	else: _collect()

func _collect() -> void:
	collected.emit(value)
	queue_free()
