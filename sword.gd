class_name Weapon
extends Area2D

signal attacked(weapon: Weapon, hit_box: HitBox)

@export var recoil := 32.0
@export var cooldown := 0.5

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _cooldown_timer: Timer = $CooldownTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_cooldown_timer.timeout.connect(_collision_shape.set_disabled.bind(false))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if not area is HitBox: return
	area.damage(1.0, null, self)
	_collision_shape.set_disabled.bind(true).call_deferred()
	_cooldown_timer.start(cooldown)
	attacked.emit(self, area)
