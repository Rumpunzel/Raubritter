class_name Coin
extends Area2D

signal collected

@export var value := 1

@export var _spawn_radius: Curve
@export var _drop_speed := 128.0
@export var _collect_duration := 0.5

@export var _collision_shape: CollisionShape2D

func _ready() -> void:
	var random_position_on_radius := Vector2(_spawn_radius.sample(randf()), 0.0).rotated(randf() * TAU)
	if _drop_speed <= 0.0:
		position += random_position_on_radius
		return
	var tween := create_tween()
	tween.tween_property(self, "position", random_position_on_radius, random_position_on_radius.length() / _drop_speed).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).as_relative()

func _collect() -> void:
	collected.emit(value)
	queue_free()

func _on_mouse_entered() -> void:
	_collision_shape.disabled = true
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, _collect_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(_collect)
