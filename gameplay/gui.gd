class_name GUI
extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_gold(gold: int) -> void:
	$MarginContainer/PanelContainer/MarginContainer/Gold/Amount.text = "%d" % gold
