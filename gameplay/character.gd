extends CharacterBody2D

@export var speed := 128.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var motion := get_global_mouse_position() - global_position
	move_and_collide(motion.normalized() * speed * delta)
