extends RangeWeapon
class_name uzi


func _physics_process(_delta: float) -> void:
	if entity.loss_of_control_effects != [] or !active:
		return

	if Input.is_action_just_pressed("reload"):
		start_reload()

	if Input.is_action_pressed("fire") and \
	fire_rate.is_stopped():
		shoot_weapon()
