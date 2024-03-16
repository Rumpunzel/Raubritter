class_name HitBox
extends Area2D

signal damaged(damage_taken: float, source: UnitInstance, weapon: WeaponInstance)

func damage(damage_taken: float, source: UnitInstance, weapon: WeaponInstance) -> void:
	damaged.emit(damage_taken, source, weapon)
