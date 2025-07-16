@tool
extends HBoxContainer
class_name ProgressBarStatus

var max_value : int
var value_progress_bar := 0 : set = _set_value_progress_bar


@onready var bar_left := $BarLeft as TextureProgressBar
@onready var bar_right := $BarRight as TextureProgressBar


func init_value(new_value) -> void:
	value_progress_bar = int(new_value)
	
	bar_left.max_value = int(new_value)
	bar_right.max_value = int(new_value)
	
	bar_left.value = int(new_value)
	bar_right.value = int(new_value)
	
	max_value = new_value


func init_value_rounds(new_value:int, actual_value:int) -> void:
	value_progress_bar = int(new_value)
	
	bar_left.max_value = int(new_value)
	bar_left.value = int(actual_value)
	
	bar_right.max_value = int(new_value)
	bar_right.value = int(actual_value)


func _set_value_progress_bar(new_value) -> void:
	value_progress_bar = min(max_value, new_value)
	
	bar_left.value = int(value_progress_bar)
	bar_right.value = int(value_progress_bar)
