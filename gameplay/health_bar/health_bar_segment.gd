class_name HealthBarSegment
extends ProgressBar

func _on_value_changed(_value: float) -> void:
	var percentage := value / max_value
	modulate = Color(1.0, percentage, percentage)
	if value <= 0.0: modulate.a = 0.25
	else: modulate.a = 1.0
