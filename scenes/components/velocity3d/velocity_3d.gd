extends Node
class_name Velocity3d

@export var gravity := 12.0

@export var max_fast_speed := 10.0
@export var max_neutral_speed := 5.0
@export var max_slow_speed := 1.0

@export var acceleration := 10.0
@export var jump_velocity := 10.0

var velocity := Vector3.ZERO

signal upward_force_applied()

func accelerate(direction: Vector3, speed : float) -> void:
	var desired_velocity := direction * speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_physics_process_delta_time()))


func apply_gravity(entity:Entity) -> void:
	if entity.velocity.y >= 0:
		entity.velocity.y -= gravity * get_physics_process_delta_time()
	else:
		entity.velocity.y -= gravity * get_physics_process_delta_time()


func apply_upward_force(entity:Entity, jump_force=jump_velocity as float) -> void:
	upward_force_applied.emit()
	entity.velocity.y = jump_force


func move(body:CharacterBody3D, ignore_y := true) -> void:
	if not ignore_y:
		body.velocity.y = velocity.y
	body.velocity.x = velocity.x
	body.velocity.z = velocity.z
	body.move_and_slide()
