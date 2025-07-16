extends Marker3D
class_name Hitscan

@export_range(1.0, 1000.0, 0.1) var cast_range := 1000.0
@export_flags_3d_physics var ray_cast_mask: int


func fire_rays(number_rays:int, spread:float, damage:float) -> Array[Dictionary]:
	var hits : Array[Dictionary] = []
	
	for i in number_rays:
		var hit_data := _cast_ray(spread)
		
		if hit_data == {}:
			continue
		
		hits.append(hit_data)
		
		if not hit_data["collider"] is Hurtbox:
			continue
		
		var hit := hit_data["collider"] as Hitbox
		hit.deal_damage(damage)
	
	return hits


#var forward_direction := global_transform.basis.z.normalized() * -1
func _cast_ray(spread:float) -> Dictionary:
	var space_state := get_world_3d().direct_space_state
	
	var adjusted_target_position := to_global(Vector3.FORWARD) + _get_random_spread_vector(spread)
	
	var direction := (adjusted_target_position - global_position).normalized()
	
	var query := PhysicsRayQueryParameters3D.create(
			global_position,
			global_position + (direction * cast_range),
			ray_cast_mask
	)
	query.collide_with_areas = true
	
	return space_state.intersect_ray(query)


func _get_random_spread_vector(spread:float) -> Vector3:
	return Vector3(
			randf_range(-spread, spread), 
			randf_range(-spread, spread), 
			randf_range(-spread, spread)
	)
