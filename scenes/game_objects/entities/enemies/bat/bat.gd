extends Enemy
class_name Bat

@export_range(0.0, 0.3, 0.001) var spread : float
@export var attack_timer_max_value := 2.0
@export var attack_timer_min_value := 4.0
@export var projectile : PackedScene
@export var num_spawn := 3

@onready var attack_timer := $AttackTimer as Timer

func _ready() -> void:
	super()
	
	ray_cast.spread = spread
	var attack_timer_value := randf_range(attack_timer_min_value, attack_timer_max_value)
	attack_timer.wait_time = attack_timer_value
	
	attack_timer.timeout.connect(_generate_attack)


func _generate_attack() -> void:
	var entity_layer := get_tree().get_first_node_in_group("projectile_layer") as Node3D
	if entity_layer == null:
		push_error("No entity layer found.")
		return
	
	if projectile == null:
		push_error("No projectile found.")
		return
	
	for i in num_spawn:
		var projectile_isntance = projectile.instantiate() as Projectile
		entity_layer.add_child(projectile_isntance)
		
		var random_direction := ray_cast.cast_ray()
		projectile_isntance.global_position = spawn_point.global_position
		projectile_isntance.look_at(projectile_isntance.global_position + random_direction, \
			Vector3.UP)
