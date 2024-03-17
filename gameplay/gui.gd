class_name GUI
extends CanvasLayer

@export var _gold_amount: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_gold_changed(gold: int) -> void:
	_gold_amount.text = "%d" % gold
