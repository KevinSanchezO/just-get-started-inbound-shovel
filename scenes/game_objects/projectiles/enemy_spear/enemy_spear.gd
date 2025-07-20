extends Node3D
class_name EnemySpear

@onready var hurtbox := $Hurtbox as Hurtbox

func _ready() -> void:
	hurtbox.disable()

func _destroy() -> void:
	queue_free()
