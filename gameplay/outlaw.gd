class_name Outlaw
extends Unit

@export var unit_class: UnitClass

@export var cost := 1
@export var upkeep := 1

func can_spawn_unit(gold: int) -> bool:
	return cost <= gold
