extends CanvasLayer
class_name GameplayUI

const text_1 = "Go in there and retrieve the 
crown. Do it before one minute
and 30 seconds or you'll die from
poison. Once finished get back to
the entry gate. Get started already"

const text_2 = "This isn't your first time dying
so you already know, get the
crown and quick.Get your shit
together and start already"

const text_3 = "Stop wasting our time. Just get
started again and get us that 
crown and get back. Quick."

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
@onready var label_briefing := $MarginContainer/Control/VBoxContainer/Label as Label
@onready var timer := $MarginContainer/Control/VBoxContainer/Timer as Timer

func _ready() -> void:
	GameplayInterface.gameplay_interface = self
	if GameplaysTracker.gameplay_counter == 1:
		label_briefing.text = text_1
	if GameplaysTracker.gameplay_counter == 2:
		label_briefing.text = text_2
	if GameplaysTracker.gameplay_counter >= 3:
		label_briefing.text = text_3
	timer.timeout.connect(_hide_briefing_label)


func _hide_briefing_label() -> void:
	label_briefing.visible = false


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
	health.health_increased.connect(_update_health_points)
	
	#first weapon
	_init_weapon_widget(weapon_widget_1, weapon_handler.available_weapons[0])
	
	#second weapon
	_init_weapon_widget(weapon_widget_2, weapon_handler.available_weapons[1])
	
	#poison
	stop_watch.start_poisoning.connect(_start_poison_settings)


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


func _start_poison_settings() -> void:
	entity.poison.poisoning = true
