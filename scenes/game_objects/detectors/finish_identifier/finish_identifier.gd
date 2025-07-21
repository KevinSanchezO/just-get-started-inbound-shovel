extends Area3D
class_name FinishIdentifier


func _ready() -> void:
	self.body_entered.connect(_on_player_entered)


func _on_player_entered(body) -> void:
	if body is Player:
		if body.mission_finished:
			get_tree().change_scene_to_file("res://scenes/user_interface/end_menu/end_menu.tscn")
