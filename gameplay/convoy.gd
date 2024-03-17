class_name Convoy
extends Unit

@export var bounty := 10

func can_spawn_unit(gold: int) -> bool:
	return bounty <= gold
