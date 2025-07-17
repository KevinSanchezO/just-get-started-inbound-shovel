extends Control
class_name CrossHair

@onready var texture := $Texture as TextureRect
@onready var timer := $Timer as Timer

func _ready() -> void:
	HitMark.hit_mark_showed.connect(_show_hit_mark)
	timer.timeout.connect(_reset_hit_mark)


func _show_hit_mark() -> void:
	texture.modulate = Color.html("#cc0404")
	timer.start()

func _reset_hit_mark() -> void:
	texture.modulate = Color.html("#ffffff")
