extends Node3D
class_name ObjectPool

@export var scene_to_pool: PackedScene
@export var initial_size := 20

var pool: Array[Node3D] = []

func _ready() -> void:
	for i in initial_size:
		var instance = scene_to_pool.instantiate()
		instance.visible = false
		pool.append(instance)
		add_child(instance)

func get_instance() -> Node3D:
	for i in pool:
		if not i.visible:
			return i
	
	# If all are in use, create a new one (optional)
	var new_instance = scene_to_pool.instantiate()
	new_instance.visible = false
	pool.append(new_instance)
	add_child(new_instance)
	return new_instance

func return_instance(instance: Node3D) -> void:
	instance.visible = false
