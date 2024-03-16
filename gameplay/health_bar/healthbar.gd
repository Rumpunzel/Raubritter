class_name Healthbar
extends Container

@export var _animation_duration := 0.2
@export var _animation_delay := 0.5
@export var _segment_size := 25.0

@export var _damage_bar: ProgressBar
@export var _health_bar: ProgressBar
@export var _segments_container: Container

@export var _health_bar_segment: PackedScene
@export var _health_bar_segment_separator: PackedScene

var unit_instance: UnitInstance :
	set(new_unit_instance):
		unit_instance = new_unit_instance
		var unit := unit_instance.unit
		update_max_hit_points(unit.hit_points)
		custom_minimum_size.y = unit.health_bar_girth
		unit_instance.hit_points_changed.connect(update_hit_points)
		unit_instance.tree_exiting.connect(queue_free)
		update_position()

var _health_bar_segments: Array[Control] = [ ]

func _process(_delta: float) -> void:
	if not unit_instance: return
	update_position()

func update_hit_points(hit_points: float, show_animation := true) -> void:
	_health_bar.value = hit_points
	for index: int in _health_bar_segments.size():
		if hit_points >= (index + 1) * _segment_size: continue
		_health_bar_segments[index].modulate.a = 0.0
	if show_animation:
		var tween := create_tween()
		tween.tween_property(_damage_bar, "value", hit_points, _animation_duration).set_delay(_animation_delay)
	else:
		_damage_bar.value = hit_points

func update_max_hit_points(max_hit_points: float) -> void:
	_health_bar_segments = [ ]
	for child: Control in _segments_container.get_children():
		_segments_container.remove_child(child)
		child.queue_free()
	_add_health_bar_segment()
	var segments_amount := floori(max_hit_points / _segment_size) - 1
	for _i: int in range(segments_amount):
		_segments_container.add_child(_health_bar_segment_separator.instantiate())
		_add_health_bar_segment()
		_damage_bar.max_value = max_hit_points
		_health_bar.max_value = max_hit_points
	update_hit_points(max_hit_points, false)

func update_position(healthbar_position: Vector2 = unit_instance.get_healthbar_position()) -> void:
	global_position = healthbar_position - size * 0.5

func _add_health_bar_segment() -> void:
	var health_bar_segment := _health_bar_segment.instantiate() as Control
	_health_bar_segments.append(health_bar_segment)
	_segments_container.add_child(health_bar_segment)
