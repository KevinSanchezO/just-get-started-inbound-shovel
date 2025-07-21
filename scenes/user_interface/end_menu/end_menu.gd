extends CanvasLayer
class_name EndMenu


@onready var timer := $Timer as Timer

func _ready() -> void:
	timer.timeout.connect(_restart_game)


func _restart_game() -> void:
	get_tree().change_scene_to_file("res://scenes/user_interface/main_menu/main_menu.tscn")
