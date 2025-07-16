extends Weapon
class_name MeleeWeapon

signal melee_used()
signal tired_stopped()

@export var hurtbox_size : Vector3

var current_hurtbox_active := false

func _ready() -> void:
	super()
	
	self.melee_used.connect(fire_rate.start)
	fire_rate.timeout.connect(tired_stopped.emit)
	
	set_hurtbox_size.call_deferred()


func perform_attack(type:String) -> void:
	melee_used.emit()
	animation.play(type)


func _screen_shake() -> void:
	Camera.apply_screen_shake(trauma)


func set_hurtbox_size() -> void:
	entity.hurtbox_melee.set_parameters(damage, hurtbox_size)
	entity.hurtbox_melee.disable()


func _handle_hurtbox() -> void:
	current_hurtbox_active = not(current_hurtbox_active)
	entity.hurtbox_melee.disable() if current_hurtbox_active else entity.hurtbox_melee.enable() 
