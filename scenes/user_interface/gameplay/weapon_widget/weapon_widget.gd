extends VBoxContainer
class_name WeaponWidget


@onready var rounds_label := $Rounds as RichTextLabel
@onready var weapon_name_label := $WeaponName as Label
@onready var progress_bar := $ProgressBarMirror as ProgressBarStatus


func set_weapon_name(weapon_name:String) -> void:
	weapon_name_label.text = weapon_name


func set_weapon_rounds_range(weapon:RangeWeapon) -> void:
	if weapon.current_max_ammo == 0:
		rounds_label.text = str("Get Fucked")
	
	if weapon.max_ammo > 0:
		rounds_label.text = str(weapon.current_max_ammo)
	else:
		rounds_label.text = str(weapon.current_chamber)


func set_weapon_round_melee(tired:bool) -> void:
	if tired:
		rounds_label.text = "[color='#cc0404']Tired[/color]"
	else:
		rounds_label.text = "Get 'Em"


func set_progress_bar(weapon:Weapon) -> void:
	if weapon is RangeWeapon:
		progress_bar.init_value_rounds(weapon.max_chamber, weapon.current_chamber)
	else:
		progress_bar.init_value_rounds(100, 100)


func reload_handling() -> void:
	rounds_label.text = "[color='#cc0404']Reloading[/color]"
