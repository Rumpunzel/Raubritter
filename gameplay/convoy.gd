class_name Convoy
extends Unit

@export var shipping_cost := 2.0

func can_spawn_unit(gold: int) -> bool:
	return bounty.get_total_bounty(get_hit_point_segments()) * shipping_cost <= gold
