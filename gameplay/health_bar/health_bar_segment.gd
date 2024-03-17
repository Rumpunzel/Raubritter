class_name HealthBarSegment
extends NinePatchRect

@export var _animation_player: AnimationPlayer

var _active := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make material unique
	material = material.duplicate()

func update_status(is_alive: bool, show_animation := true) -> void:
	if is_alive == _active: return
	_active = is_alive
	if _active: construct(show_animation)
	else: destroy(show_animation)

func construct(show_animation: bool) -> void:
	if show_animation:
		modulate.a = 1.0
	else:
		modulate.a = 1.0

func destroy(show_animation: bool) -> void:
	if show_animation:
		_animation_player.play("destroy")
	else:
		modulate.a = 0.0
