extends Area3D
class_name EnemyActivator

@export var enemy_1 : Enemy
@export var enemy_2 : Enemy
@export var enemy_3 : Enemy
@export var enemy_4 : Enemy
@export var enemy_5 : Enemy
@export var enemy_6 : Enemy

@export var door_1 : Door
@export var door_2 : Door

var already_passed := false

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	var lsit := [enemy_1,enemy_2,enemy_3,enemy_4,enemy_5,enemy_6]
	for i in lsit:
		if i != null:
			return
	door_2.open_door()
	queue_free()

func _on_body_entered(body) -> void:
	if already_passed:
		return
	if body is Player:
		already_passed = true
		door_1.close_door()
		if enemy_1 != null:
			enemy_1.initialize_behaviour(get_tree().get_first_node_in_group("player"))
		if enemy_2 != null:
			enemy_2.initialize_behaviour(get_tree().get_first_node_in_group("player"))
		if enemy_3 != null:
			enemy_3.initialize_behaviour(get_tree().get_first_node_in_group("player"))
		if enemy_4 != null:
			enemy_4.initialize_behaviour(get_tree().get_first_node_in_group("player"))
		if enemy_5 != null:
			enemy_5.initialize_behaviour(get_tree().get_first_node_in_group("player"))
		if enemy_6 != null:
			enemy_6.initialize_behaviour(get_tree().get_first_node_in_group("player"))
