extends Enemy
class_name Soldier

@export_range(0.0, 0.3, 0.001) var spread : float
@export var attack_timer_max_value := 2.0
@export var attack_timer_min_value := 5.0
@export var projectile : PackedScene
@export var lance : PackedScene
@export var num_spawn_orb := 8
@export var num_spawn_spear := 4

@onready var attack_timer := $AttackTimer as Timer
@onready var animation_model := $ModelContainer/KnightModel/AnimationPlayer as AnimationPlayer

func _ready() -> void:
	super()
	
	ray_cast.spread = spread
	_modify_timer_value(attack_timer, attack_timer_max_value, attack_timer_min_value)
	
	attack_timer.timeout.connect(_generate_attack)

func _generate_attack() -> void:
	if target == null:
		return
	
	var select_attack = randi_range(1, 2)
	if select_attack == 1:
		_generate_orb()
	else:
		_generate_spear()
	_modify_timer_value(attack_timer, attack_timer_max_value, attack_timer_min_value)


func _generate_orb() -> void:
	var entity_layer := get_tree().get_first_node_in_group("projectile_layer") as Node3D
	if entity_layer == null:
		push_error("No entity layer found.")
		return
	
	if lance == null:
		push_error("No projectile found.")
		return
	
	if loss_of_control_effects != []:
		return
	
	attack_sfx.play_audio()
	
	for i in num_spawn_orb:
		var projectile_isntance = projectile.instantiate() as Projectile
		entity_layer.add_child(projectile_isntance)
		
		var random_direction := ray_cast.cast_ray()
		projectile_isntance.global_position = spawn_point.global_position
		projectile_isntance.look_at(projectile_isntance.global_position + random_direction, \
			Vector3.UP)


func _generate_spear() -> void:
	var entity_layer := get_tree().get_first_node_in_group("projectile_layer") as Node3D
	if entity_layer == null:
		push_error("No entity layer found.")
		return
	
	if lance == null:
		push_error("No lance found.")
		return
	
	if target == null:
		push_error("No target to spawn Lance")
		return
	
	if loss_of_control_effects != []:
		return
	
	await get_tree().create_timer(0.1).timeout
	for i in num_spawn_spear:
		var lance_isntance = lance.instantiate() as EnemySpear
		entity_layer.add_child(lance_isntance)
		lance_isntance.global_position.z = target.global_position.z
		lance_isntance.global_position.x = target.global_position.x
		lance_isntance.global_position.y = self.global_position.y
		await get_tree().create_timer(0.2).timeout
