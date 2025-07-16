extends Area3D
class_name Hurtbox

@export var damage := 0.0

signal damage_dealt
signal limit_impacted


func _ready() -> void:
	self.area_entered.connect(_on_area_entered)
	self.body_entered.connect(_on_body_entered)


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


func set_parameters(damage_value:float, size:Vector3, child = 0) -> void:
	damage = damage_value
	
	var collision = get_child(child)
	if collision is CollisionShape3D:
		if collision.shape is BoxShape3D:
			collision.shape.set_size(size)


func _on_area_entered(area) -> void:
	if area is Hitbox:
		area.deal_damage(damage)
		damage_dealt.emit()


func _on_body_entered(body) -> void:
	if body.get_collision_layer() == 1:
		limit_impacted.emit()
