extends Weapon
class_name RangeWeapon

signal chamber_modified()
signal weapon_fired()
signal reload_started()

@export var projectiles_per_shoot : int
@export_range(0.0, 0.3, 0.001) var spread : float
@export var max_ammo : int
@export var max_chamber : int
@export var reload_time := 0.1
@export var recoil : Vector3
@export var recoil_mult := 0.2
@export var bullet_trail : PackedScene

var current_max_ammo : int
var current_chamber : int
var raycast : Hitscan

@onready var spawner := $Spawner as Node3D
@onready var muzzle_flash := %MuzzleFlash as MuzzleFlash
@onready var reload_timer := $ReloadTimer as Timer
@onready var recoil_timer := $RecoilTimer as Timer
@onready var current_recoil := recoil


func _ready() -> void:
	super()
	
	current_max_ammo = max_ammo
	current_chamber = max_chamber
	
	reload_timer.wait_time = reload_time
	recoil_timer.wait_time = fire_rate_value
	
	self.weapon_fired.connect(fire_rate.start)
	self.weapon_fired.connect(muzzle_flash.start_muzzle_flash)
	
	reload_timer.timeout.connect(_reload)


func start_reload() -> void:
	if current_chamber == max_chamber:
		return
	
	reload_timer.start()
	reload_started.emit()


func _reload() -> void:
	var bullets_needed := max_chamber - current_chamber
	
	if current_max_ammo >= bullets_needed:
		current_max_ammo -= bullets_needed
		current_chamber = max_chamber
	else:
		current_chamber += current_max_ammo
		current_max_ammo = 0

	#reload_audio.play_audio()
	chamber_modified.emit()


func shoot_weapon() -> void:
	var bullet_trail_pool := get_tree().get_first_node_in_group("object_pool_bullet_trail") as ObjectPool
	if bullet_trail_pool == null:
		push_error("No entity layer found.")
		return
	
	if current_chamber == 0:
		return
	
	firing = true
	
	if animation.is_playing():
		animation.stop()
	animation.play("fire")
	
	var hits := raycast.fire_rays(projectiles_per_shoot, spread, damage)
	for i in hits.size():
		var hit := hits[i]
		var trail = bullet_trail_pool.get_instance() as BulletTrail
		trail.init(spawner.global_position ,hit["position"], bullet_trail_pool)
	
	firing = false
	current_chamber -= 1
	Camera.apply_procedural_recoil(current_recoil)
	recoil_timer.start()
	Camera.apply_screen_shake(trauma)
	weapon_fired.emit()
	chamber_modified.emit()


func _update_recoil() -> void:
	var new_recoil:Vector3
	new_recoil = Vector3(\
		current_recoil.x + (current_recoil.x * recoil_mult), \
		current_recoil.y + (current_recoil.y * recoil_mult), \
		current_recoil.z + (current_recoil.z * recoil_mult)\
	)
	current_recoil = new_recoil


func _set_default_recoil() -> void:
	current_recoil = recoil


func _play_range_audio(range_audio:RangeAudio) -> void:
	range_audio.play_audio(current_chamber, max_chamber)
