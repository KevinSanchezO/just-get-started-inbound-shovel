extends Entity
class_name Enemy

@export var rotation_speed := 0.15
@export var proximity_target_value := 6.0

@onready var entity_navigation := $EntityNavigation as EntityNavigation
@onready var spawn_point := %SpawnPointProjectile as Node3D
@onready var ray_cast := %RayCast as RayCast

var target : Player
var direction_towards_target : Vector3


func _ready() -> void:
	health.died.connect(queue_free)
	hitbox.damage_received.connect(HitMark.show_hit_mark)
	initialize_behaviour(get_tree().get_first_node_in_group("player"))


func _process(_delta: float) -> void:
	direction_towards_target = entity_navigation.direction_path.normalized()


func _physics_process(_delta: float) -> void:
	velocity_3d.apply_gravity(self)
	
	if target == null:
		return
	if loss_of_control_effects != []:
		return
	
	if entity_navigation.is_navigating:
		_y_rotate_towards(model_container)
		if not _target_in_proximity():
			velocity_3d.accelerate(direction_towards_target, velocity_3d.max_neutral_speed)
			velocity_3d.move(self)


func _y_rotate_towards(component_rotate:Node3D) -> void:
	var pos2d := Vector2(global_position.x, global_position.z) as Vector2
	var targetPos2d := Vector2(target.global_position.x, \
	target.global_position.z) as Vector2
	var direction = (pos2d - targetPos2d)
	component_rotate.rotation.y = lerp_angle(component_rotate.rotation.y, \
		atan2(direction.x, direction.y), \
		get_physics_process_delta_time() / rotation_speed)


func _target_in_proximity() -> bool:
	if target == null:
		return false
	
	var target_pos := target.global_transform.origin
	var entity_pos := self.global_transform.origin
	
	var distance := entity_pos.distance_to(target_pos)
	
	return distance < proximity_target_value


func initialize_behaviour(target_scene, _started_by_hive:=false) -> void:
	if target != null:
		return
	
	target = target_scene
	entity_navigation.target = target
	entity_navigation.is_navigating = true
