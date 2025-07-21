extends Node
class_name Poison

@export var damage_timer_value := 2.0
@export var poison_damage := 3.0
@export var hitbox : Hitbox

@onready var damage_timer := $Timer as Timer

var poisoning := false


func _ready() -> void:
	damage_timer.timeout.connect(_poison_entity)


func _poison_entity() -> void:
	if poisoning:
		hitbox.deal_damage(poison_damage)
