extends Node3D
class_name WeaponHandler

signal weapon_changed()

const MAX_NUMBER_WEAPONS := 2

@export var entity : Player
@export var hurtbox_melee : Hurtbox
@export var hitscan : Hitscan

var active_weapon : Weapon
var available_weapons := []


func ready_weapon_handler() -> void:
	_load_weapons.call_deferred()


func _load_weapons() -> void:
	var weapons := WeaponDB.select_random_weapons()
	
	for weapon_to_load in weapons:
		var weapon_scene := load(weapon_to_load) as PackedScene
		var weapon_instance := weapon_scene.instantiate() as Weapon
		available_weapons.append(weapon_instance)
		self.add_child(weapon_instance)
		weapon_instance.global_position = self.global_position
		
		weapon_instance.entity = entity
		if weapon_instance is RangeWeapon:
			weapon_instance.raycast = hitscan
		
		weapon_instance.visible = false
	
	active_weapon = available_weapons[0]
	active_weapon.activate_weapon()
	active_weapon.visible = true


func switch_weapon() -> void:
	if available_weapons.size() == 1 or available_weapons.size() == 0:
		return
	
	if active_weapon.firing:
		return
	
	var previous_weapon = active_weapon
	if previous_weapon == available_weapons[0]:
		active_weapon = available_weapons[1]
	else:
		active_weapon = available_weapons[0]
	
	previous_weapon.visible = false
	previous_weapon.active = false
	
	active_weapon.visible = true
	active_weapon.activate_weapon()
	weapon_changed.emit()
