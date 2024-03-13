extends CharacterBody2D

@export var speed := 128.0

@onready var navgiation_agent: NavigationAgent2D = %NavigationAgent2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	navgiation_agent.target_position = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	var motion := navgiation_agent.get_next_path_position()
	print(motion)
	move_and_collide(motion.normalized() * speed * delta)
