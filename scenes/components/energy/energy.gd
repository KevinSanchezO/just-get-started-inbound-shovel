extends Node
class_name Energy

signal energy_changed()
signal cooldown_ended()

@export var max_energy := 100.0
@export var recovery := 1.0
@export var consumption_timer_value := 0.05
@export var consumption_sprint := 1.0

@onready var energy_value := max_energy
@onready var consumption_timer := $Timer as Timer

var is_consuming := false

func _ready() -> void:
	consumption_timer.wait_time = consumption_timer_value
	consumption_timer.timeout.connect(_on_consumption_timer_timeout)


func modify_gauge_directly(value) -> void:
	energy_value = maxf(energy_value - value, 0.0)
	energy_changed.emit()


func _on_consumption_timer_timeout() -> void:
	if !is_consuming:
		if energy_value < max_energy:
			energy_value = minf(energy_value + recovery, max_energy)
		else:
			cooldown_ended.emit()
	else:
		energy_value = maxf(energy_value - consumption_sprint, 0.0)
	energy_changed.emit()
