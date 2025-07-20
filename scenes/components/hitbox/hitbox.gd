extends Area3D
class_name Hitbox

signal damage_received()

@export var health : Health


func enable() -> void:
	for i in get_child_count():
		var child := get_child(i)
		if not child is CollisionShape3D and not child is CollisionPolygon3D:
			continue
		
		child.disabled = false


func disable() -> void:
	for i in get_child_count():
		var child := get_child(i)
		if not child is CollisionShape3D and not child is CollisionPolygon3D:
			continue
		child.disabled = true


func deal_damage(attack_value: float):
	if health == null:
		push_error("No health component detected")
		return
	
	health.damage(attack_value)
	damage_received.emit()
