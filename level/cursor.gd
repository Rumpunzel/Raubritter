extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = get_global_mouse_position()

func _on_area_entered(area: Area2D) -> void:
	if area is Coin: area.collect(self)
