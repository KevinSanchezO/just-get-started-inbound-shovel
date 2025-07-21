extends Area3D
class_name Crown

@onready var sfx := $RandomPitchAudio as RandomPitchAudio

@export var door_1 : Door
@export var door_2 : Door
@export var door_3 : Door

func _ready() -> void:
	self.body_entered.connect(_on_player_entered)
	sfx.finished.connect(queue_free)


func _on_player_entered(body) -> void:
	var music := get_tree().get_first_node_in_group("music") as BGMusic
	if body is Player:
		body.mission_finished  = true
		self.visible = false
		music.play_next = true
		sfx.play_audio()
		door_1.open_door()
		door_2.open_door()
		door_3.open_door()
		
