extends Node3D
class_name Weapon

@export var weapon_name : String
@export var fire_rate_value := 0.1
@export_range(0.0, 5.0, 0.05) var trauma : float
@export var damage := 0.0

@onready var fire_rate := $FireRate as Timer
@onready var animation := $AnimationPlayer as AnimationPlayer

var active := false
var can_change := true
var firing := false
var entity : Player

func _ready() -> void:
	fire_rate.wait_time = fire_rate_value

func activate_weapon() -> void:
	can_change = true
	active = true
