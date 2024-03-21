class_name Clock
extends MarginContainer

@export var _animation_vector := Vector2i(0, -100)
@export var _animation_duration := 0.5
@export var _start_hidden := false

@export var _hours: Label
@export var _minutes: Label

var _margin_vector: Vector2i :
	get: return Vector2i(get_theme_constant("margin_left"), get_theme_constant("margin_top"))
	set(new_margin_vector):
		add_theme_constant_override("margin_top", new_margin_vector.y)
		add_theme_constant_override("margin_left", new_margin_vector.x)
		add_theme_constant_override("margin_bottom", -new_margin_vector.y)
		add_theme_constant_override("margin_right", -new_margin_vector.x)

func _ready() -> void:
	if _start_hidden: hide_clock(false)

func set_time(time: float) -> void:
	var hours := floori(time)
	var minutes := floori((time - hours) * 60.0)
	_hours.text = "%d" % hours
	_minutes.text = "%02d" % minutes

func hide_clock(show_animation := true) -> void:
	if not show_animation:
		_margin_vector = _animation_vector
		return
	var tween := create_tween()
	tween.tween_property(self, "_margin_vector", _animation_vector, _animation_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

func show_clock(show_animation := true) -> void:
	if not show_animation:
		_margin_vector = Vector2i.ZERO
		return
	var tween := create_tween()
	tween.tween_property(self, "_margin_vector", Vector2i.ZERO, _animation_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
