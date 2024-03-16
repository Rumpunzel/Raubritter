class_name HitBox
extends Area2D

signal damaged(damage_taken: float, source: UnitInstance, weapon: Weapon)

func damage(damage_taken: float, source: UnitInstance, weapon: Weapon) -> void:
	damaged.emit(damage_taken, source, weapon)
