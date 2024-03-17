class_name Bounty
extends Resource

@export var coins_for_kill := 10
@export var coins_for_segment := 1

func get_total_bounty(hit_point_segments: int) -> int:
	return coins_for_kill + coins_for_segment * hit_point_segments
