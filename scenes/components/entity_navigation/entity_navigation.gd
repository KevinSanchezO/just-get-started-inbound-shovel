extends Node3D
class_name EntityNavigation


const MOVEMENT_SPEED := 150.0 as float

@export var radius_value := 2.0 #same as the collision shape

var is_navigating := false
var target : Node3D
var direction_path : Vector3

@onready var navigation_agent := $NavigationAgent3D as NavigationAgent3D

func _ready() -> void:
	navigation_agent.radius = radius_value
	navigation_agent.max_speed = MOVEMENT_SPEED
	navigation_agent.velocity_computed.connect(_determine_path)


func _process(_delta: float) -> void:
	if not is_navigating:
		return
	if target == null:
		return
	
	navigation_agent.target_position = target.global_position
	
	var axis = to_local(navigation_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * MOVEMENT_SPEED
	navigation_agent.set_velocity(intended_velocity)


func _determine_path(safe_velocity) -> void:
	if is_navigating:
		direction_path = safe_velocity
