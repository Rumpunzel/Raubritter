class_name Healthbar
extends HBoxContainer

@export var _segment_size := 25.0
@export var _health_bar_segment: PackedScene

func update_hit_points(hit_points: float, show_animation := true) -> void:
	for index: int in get_child_count():
		var health_bar_segment: HealthBarSegment = get_child(index)
		health_bar_segment.value = clampf(hit_points - index * _segment_size, 0.0, _segment_size)

func update_max_hit_points(max_hit_points: float) -> void:
	for child: HealthBarSegment in get_children():
		remove_child(child)
		child.queue_free()
	for _i: int in range(ceili(max_hit_points / _segment_size)):
		var health_bar_segment := _health_bar_segment.instantiate() as HealthBarSegment
		add_child(health_bar_segment)
		health_bar_segment.max_value = _segment_size
	update_hit_points(max_hit_points)

func update_position(character_controller: CharacterController) -> void:
	global_position = character_controller.global_position - Vector2(0.0, character_controller.health_bar_offset) - size * 0.5
