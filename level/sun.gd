class_name Sun
extends CanvasModulate

signal time_of_day_changed(time: float)

enum DayTime {
	NIGHT = 0,
	DAWN = 6,
	NOON = 12,
	DUSK = 18,
}

@export var _color_gradient: Gradient
@export var _lerp_speed := 1.0

var time_of_day := float(DayTime.DAWN) :
	set(new_time_of_day):
		time_of_day = new_time_of_day
		while time_of_day >= 24.0: time_of_day -= 24.0
		time_of_day_changed.emit(time_of_day)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color = _color_for_time_of_day()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	color = color.lerp(_color_for_time_of_day(), _lerp_speed * delta)

func _color_for_time_of_day() -> Color:
	return _color_gradient.sample(time_of_day / 24.0)
