extends Weapon
class_name MeleeWeapon

signal melee_used()
signal tired_stopped()

@onready var attack_sfx := %AttackSFX as RandomPitchAudio

@export var hurtbox_size : Vector3

func _ready() -> void:
	super()
	
	self.melee_used.connect(fire_rate.start)
	self.melee_used.connect(attack_sfx.play_audio)
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


func _enable_hurtbox() -> void:
	entity.hurtbox_melee.enable() 


func _disable_hurtbox() -> void:
	entity.hurtbox_melee.disable()
