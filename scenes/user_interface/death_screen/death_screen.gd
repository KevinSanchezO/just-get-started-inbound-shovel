extends CanvasLayer
class_name DeathScreen

@onready var timer := $Timer as Timer


func _ready() -> void:
	timer.timeout.connect(_retry)


func _retry() -> void:
	get_tree().change_scene_to_file("res://scenes/gameplay/stage_gameplay/stage_gameplay.tscn")
