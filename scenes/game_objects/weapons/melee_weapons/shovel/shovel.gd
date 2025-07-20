extends MeleeWeapon
class_name Shovel



func _physics_process(_delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if Input.is_action_just_pressed("fire") and \
	fire_rate.is_stopped():
		perform_attack("quick_hit")
