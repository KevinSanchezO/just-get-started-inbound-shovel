extends Node

signal hit_mark_showed()


func show_hit_mark() -> void:
	hit_mark_showed.emit()
