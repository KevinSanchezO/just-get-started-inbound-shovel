extends RangeWeapon
class_name Crossbow

@onready var charging_vfx := %Charging as Sprite3D
@onready var charged_vfx := %Charged as Sprite3D

@export var charged_limit := 50.0
@export var increase_value := 1.0

var charging := false
var current_charge := 0.0
var charge_complete : bool :
	get:
		return current_charge >= charged_limit


func _ready() -> void:
	super()
	charging_vfx.visible = false
	charged_vfx.visible = false


func _physics_process(delta: float) -> void:
	charging_vfx.rotation.z += 5 * delta
	charged_vfx.rotation.z += 5 * delta
	
	if entity.loss_of_control_effects != [] or !active:
		return
	
	if Input.is_action_pressed("fire") and fire_rate.is_stopped():
		_handle_charging()
	
	if Input.is_action_just_released("fire") and fire_rate.is_stopped():
		_handle_release()


func _handle_release() -> void:
	if charge_complete:
		shoot_weapon()
	can_change = true
	charging = false
	current_charge = 0.0
	
	charged_vfx.visible = false
	charging_vfx.visible = false


func _handle_charging() -> void:
	can_change = false
	charging = true
	
	current_charge += increase_value
	
	if charge_complete:
		charged_vfx.visible = true
		charging_vfx.visible = false
	else:
		charged_vfx.visible = false
		charging_vfx.visible = true
