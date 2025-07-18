extends AudioStreamPlayer3D
class_name RangeAudio

@export var randomize_pitch := true
@export var max_pitch := 1.1
@export var min_pitch := 0.8

func play_audio(current_value: int, max_value: int) -> void:
	if stream == null:
		return

	var normalized = clamp(1.0 - float(current_value) / float(max_value), 0.0, 1.0)
	pitch_scale = lerp(max_pitch, min_pitch, normalized)

	play()
