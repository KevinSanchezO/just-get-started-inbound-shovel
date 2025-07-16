extends CanvasLayer
class_name GameplayUI


var entity : Player

var energy : Energy
var health : Health
var weapon_handler : WeaponHandler

@onready var stop_watch := %StopWatch as StopWatch
@onready var cross_hair := %CrossHair as CrossHair
@onready var weapon_widget_1 := %WeaponWidget as WeaponWidget
@onready var weapon_widget_2 := %WeaponWidget2 as WeaponWidget
@onready var progress_bar_health := %ProgressBarHealth as ProgressBarStatus
@onready var progress_bar_energy := %ProgressBarEnergy as ProgressBarStatus


func _ready() -> void:
	GameplayInterface.gameplay_interface = self


func _process(_delta: float) -> void:
	if energy != null:
		progress_bar_energy.value_progress_bar = energy.energy_value


func gameplay_ui_config() -> void:
	entity = get_tree().get_first_node_in_group("player")
	
	energy = entity.energy
	health = entity.health
	weapon_handler = entity.weapon_handler
	
	#energy widget
	progress_bar_energy.init_value(energy.energy_value)
	
	#health
	progress_bar_health.init_value(health.current_health)
	health.health_reduced.connect(_update_health_points)
	
	#first weapon
	_init_weapon_widget(weapon_widget_1, weapon_handler.available_weapons[0])
	
	#second weapon
	_init_weapon_widget(weapon_widget_2, weapon_handler.available_weapons[1])


func _update_health_points() -> void:
	progress_bar_health.value_progress_bar = health.current_health


func _init_weapon_widget(widget:WeaponWidget, weapon:Weapon) -> void:
	widget.set_weapon_name(weapon.weapon_name)
	
	if weapon is RangeWeapon:
		widget.set_weapon_rounds_range(weapon)
		
		weapon.chamber_modified.connect(Callable(_update_weapon_widget_range).bind(\
		widget, weapon))
		
		weapon.reload_started.connect(Callable(_reload).bind(widget))
	if weapon is MeleeWeapon:
		widget.set_weapon_round_melee(false)
		
		weapon.melee_used.connect(Callable(_status_melee).bind(widget, true))
		weapon.tired_stopped.connect(Callable(_status_melee).bind(widget, false))
	
	widget.set_progress_bar(weapon)


func _update_weapon_widget_range(widget: WeaponWidget, weapon:RangeWeapon) -> void:
	widget.set_weapon_rounds_range(weapon)
	widget.set_progress_bar(weapon)


func _reload(widget: WeaponWidget) -> void:
	widget.reload_handling()


func _status_melee(widget: WeaponWidget, tired:bool):
	widget.set_weapon_round_melee(tired)
