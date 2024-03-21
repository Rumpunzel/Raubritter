class_name GUI
extends CanvasLayer

@export var _clock: Clock
@export var _gold_amount: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_time_of_day_changed(time: float) -> void:
	_clock.set_time(time)

func _on_gold_changed(gold: int) -> void:
	_gold_amount.text = "%d" % gold

func _on_phase_changed(phase: Main.Phases) -> void:
	if phase == Main.Phases.BUILD: _clock.hide_clock()
	elif phase == Main.Phases.FIGHT: _clock.show_clock()
