extends CanvasLayer
class_name MainMenu

const limit_to_transition := 1.2

var in_controls := false
var value_progress := 0.0

@onready var music := $AudioStreamPlayer as AudioStreamPlayer

@onready var title := %Title as Control
@onready var title_label := %TitleLabel as RichTextLabel
@onready var start_button := %StartButton as Button

@onready var controls := %Controls as Control
@onready var monologue := %Monologue as Label

func _ready() -> void:
	GameplaysTracker.gameplay_counter = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	music.play()
	title.visible = true
	controls.visible = false
	
	title_label.modulate.a = 0
	start_button.modulate.a = 0
	start_button.disabled = true
	
	_ready_title()


func _physics_process(delta: float) -> void:
	if in_controls:
		var multiplier := 0.1
		if Input.is_anything_pressed():
			multiplier = 0.2
		monologue.visible_ratio += minf(delta*multiplier, 1.0)
		value_progress += delta*multiplier
	if limit_to_transition <= value_progress:
		get_tree().change_scene_to_file("res://scenes/gameplay/stage_gameplay/stage_gameplay.tscn")


func _ready_title() -> void:
	var tween_title_label := get_tree().create_tween() as Tween
	var tween_start_button := get_tree().create_tween() as Tween
	
	tween_title_label.tween_property(title_label, "modulate:a",\
	1.0, 2.0).from(title_label.modulate.a)
	
	tween_start_button.tween_property(start_button, "modulate:a",\
	1.0, 4.0).from(start_button.modulate.a)
	
	await  tween_start_button.finished
	start_button.disabled = false
	start_button.pressed.connect(_start_button_pressed)


func _start_button_pressed() -> void:
	title.visible = false
	controls.visible = true
	in_controls = true
