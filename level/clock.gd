class_name Clock
extends HBoxContainer

@export var _hours: Label
@export var _minutes: Label

func set_time(time: float) -> void:
	var hours := floori(time)
	var minutes := floori((time - hours) * 60.0)
	_hours.text = "%d" % hours
	_minutes.text = "%02d" % minutes
