extends Node
class_name BGMusic

var currently_playing : AudioStreamPlayer
var next : AudioStreamPlayer
var play_next : bool

@onready var beginning := $Beginning as AudioStreamPlayer
@onready var middle := $Middle as AudioStreamPlayer
@onready var end := $End as AudioStreamPlayer


func _ready() -> void:
	currently_playing = middle
	next = end
	play_next = false
	
	currently_playing.play()
	beginning.finished.connect(_handle_transition)
	middle.finished.connect(_handle_transition)


func _handle_transition() -> void:
	if not play_next:
		currently_playing.play()
		return
	
	currently_playing.stop()
	next.play()
	currently_playing = next
	
	if currently_playing == middle:
		next = end
