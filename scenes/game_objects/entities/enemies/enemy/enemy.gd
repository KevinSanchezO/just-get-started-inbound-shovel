extends Entity
class_name Enemy

@export var rotation_speed := 0.15
@export var proximity_target_value := 6.0
@export_flags_3d_physics var death_coll_mask: int

@export var max_sfx_timer := 3.0
@export var min_sfx_timer := 5.0

@onready var collision_shape := $CollisionShape3D as CollisionShape3D
@onready var spawn_point := %SpawnPointProjectile as Node3D
@onready var ray_cast := %RayCast as RayCast
@onready var entity_navigation := $EntityNavigation as EntityNavigation
@onready var sfx_timer := $SFXTimer as Timer

@onready var entity_sfx := %EntitySFX as RandomPitchAudio
@onready var attack_sfx := %AttackSFX as RandomPitchAudio
@onready var death_sfx := %DeathSFX as RandomPitchAudio

var target : Player
var direction_towards_target : Vector3


func _ready() -> void:
	health.died.connect(_start_death)
	hitbox.damage_received.connect(HitMark.show_hit_mark)
	_modify_timer_value(sfx_timer, min_sfx_timer, max_sfx_timer)
	sfx_timer.timeout.connect(_on_sfx_timer_timeout)
	death_sfx.finished.connect(queue_free)
	
	#initialize_behaviour(get_tree().get_first_node_in_group("player"))


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

func _modify_timer_value(timer:Timer, min_value:float, max_value:float) -> void:
	var timer_value := randf_range(min_value, max_value)
	timer.wait_time = timer_value
	timer.start()


func _start_death() -> void:
	hitbox.disable()
	collision_shape.shape = null
	loss_of_control_effects.append(self)
	model_container.visible = false
	death_sfx.play_audio()



func _on_sfx_timer_timeout() -> void:
	if loss_of_control_effects != []:
		return
	_modify_timer_value(sfx_timer, min_sfx_timer, max_sfx_timer)
	entity_sfx.play_audio()
