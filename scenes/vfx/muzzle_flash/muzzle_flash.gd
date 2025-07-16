extends Sprite3D
class_name MuzzleFlash

@onready var timer := $Timer as Timer
@onready var light := $OmniLight3D as OmniLight3D

@export var light_range := 7.0
@export var timer_value := 0.05

func _ready() -> void:
	timer.wait_time = timer_value
	light.omni_range = light_range
	
	timer.timeout.connect(_restart_muzzle_flash)
	_restart_muzzle_flash()

func start_muzzle_flash() -> void:
	self.visible = true
	timer.start()

func _restart_muzzle_flash() -> void:
	self.visible = false
