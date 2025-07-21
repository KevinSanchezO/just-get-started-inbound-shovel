extends RigidBody3D
class_name Door


func open_door() -> void:
	self.global_position.y = 5.0

func close_door() -> void:
	self.global_position.y = 0.0
