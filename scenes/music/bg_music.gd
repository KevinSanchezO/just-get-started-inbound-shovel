extends Node
class_name BGMusic

var currently_playing : AudioStreamPlayer
var next : AudioStreamPlayer
var play_next : bool

@onready var beginning := $Beginning as AudioStreamPlayer
@onready var middle := $Middle as AudioStreamPlayer
@onready var end := $End as AudioStreamPlayer


func _ready() -> void:
	currently_playing = beginning
	next = middle
	play_next = true
	
	currently_playing.play()
	beginning.finished.connect(_handle_transition)
	middle.finished.connect(_handle_transition)


func _handle_transition() -> void:
	print("transition")
	if not play_next:
		return
	
	currently_playing.stop()
	next.play()
	currently_playing = next
	
	if currently_playing == middle:
		next = end
