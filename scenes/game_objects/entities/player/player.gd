extends Entity
class_name Player

@export_group("Mouse Sensitivity")
@export_range(0.001, 0.01, 0.0001) var mouse_sensitivity := 0.005

@export_group("Base Tilt")
@export var tilt := 3.0
@export var time_tilt := 0.05

@export_group("Weapon holder")
@export var weapon_rotation := 0.001

@export_group("Head Bob")
@export var headbob_frequency := 2.0
@export var headbob_amplitude := 0.08

@onready var energy := $Energy as Energy
@onready var poison := $Poison as Poison
@onready var head := %Head as Node3D
@onready var view_container := %ViewContainer as Node3D
@onready var camera_container := %CameraContainer as CameraContainer
@onready var game_camera := %GameCamera as GameCamera
@onready var hurtbox_melee := %Hurtbox as Hurtbox
@onready var hitscan := %Hitscan as Hitscan
@onready var weapon_handler := %WeaponHandler as WeaponHandler
@onready var animation := $AnimationPlayer as AnimationPlayer

@onready var move_sfx := $AudioContainer/Move as RandomPitchAudio
@onready var hurt_sfx := $AudioContainer/Hurt as RandomPitchAudio
@onready var death_sfx := $AudioContainer/Death as RandomPitchAudio


var sprint_lock := false
var sprint_input_pressed := false
var headbob_time := 0.0
var mouse_input : Vector2
var mouse_capture := true
var on_ground : bool
var sprinting : bool :
	set(value):
		energy.is_consuming = value
		sprinting = value

var mission_finished := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	on_ground = is_on_floor()
	
	for child in model_container.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true)
	
	weapon_handler.ready_weapon_handler()
	_set_gameplay_ui.call_deferred()
	hurtbox_melee.disable()
	hitbox.damage_received.connect(hurt_sfx.play_audio)
	health.died.connect(_start_death)
	death_sfx.finished.connect(_restart_after_death)


func _start_death() -> void:
	hitbox.disable()
	loss_of_control_effects.append(self)
	weapon_handler.visible = false
	animation.play("death")
	death_sfx.play_audio()


func _restart_after_death() -> void:
	await get_tree().create_timer(0.5).timeout
	GameplaysTracker.gameplay_counter += 1
	get_tree().change_scene_to_file("res://scenes/user_interface/death_screen/death_screen.tscn")


func _set_gameplay_ui() -> void:
	GameplayInterface.gameplay_interface.gameplay_ui_config()


func _unhandled_input(event) -> void:
	if loss_of_control_effects != []:
		return
	
	if Input.is_action_just_pressed("switch_weapon"):
		weapon_handler.switch_weapon()
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * mouse_sensitivity)
		view_container.rotate_x(-event.relative.y * mouse_sensitivity)
		view_container.rotation.x = clamp(view_container.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		mouse_input = event.relative


func _physics_process(_delta: float) -> void:
	if mouse_capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	velocity_3d.apply_gravity(self)
	
	if loss_of_control_effects != []:
		return
	
	var input_dir := get_input_dir()
	
	wish_dir = head.global_transform.basis * Vector3(input_dir.x, 0.0, -input_dir.y)
	
	velocity_3d.accelerate(wish_dir, _get_velocity())
	velocity_3d.move(self)
	
	_handle_sprint(input_dir)
	
	_head_tilt(input_dir)
	_weapon_tilt(input_dir)
	_weapon_sway()
	_head_bob()


func get_input_dir() -> Vector2:
	return Input.get_vector("left", "right", "down", "up").normalized()


func _handle_sprint(input_dir:Vector2) -> void:
	var sprint_pressed := Input.get_action_strength("sprint")
	
	if energy.energy_value == 0 and sprint_pressed:
		sprint_lock = true
	
	if !sprint_pressed:
		sprint_lock = false
	
	sprinting = sprint_pressed and \
		!sprint_lock and \
		input_dir != Vector2.ZERO and \
		energy.energy_value > 0


func _get_velocity() -> float:
	if !sprinting:
		return velocity_3d.max_neutral_speed
	else:
		return velocity_3d.max_fast_speed


func _head_tilt(input_dir:Vector2) -> void:
	if input_dir.x > 0:
		game_camera.rotation.z = lerp_angle(game_camera.rotation.z, deg_to_rad(-tilt), time_tilt)
	elif input_dir.x < 0:
		game_camera.rotation.z = lerp_angle(game_camera.rotation.z, deg_to_rad(tilt), time_tilt)
	else:
		game_camera.rotation.z = lerp_angle(game_camera.rotation.z, deg_to_rad(0), time_tilt)
	
	if input_dir.y > 0:
		head.rotation.x = lerp_angle(head.rotation.x, deg_to_rad(-tilt), time_tilt)
	elif input_dir.y < 0:
		head.rotation.x = lerp_angle(head.rotation.x, deg_to_rad(tilt), time_tilt)
	else:
		head.rotation.x = lerp_angle(head.rotation.x, deg_to_rad(0), time_tilt)


func _weapon_tilt(input_dir:Vector2) -> void:
	if input_dir.x > 0:
		weapon_handler.rotation.z = lerp_angle(weapon_handler.rotation.z, \
			deg_to_rad(-5), 0.05)
	elif input_dir.x < 0:
		weapon_handler.rotation.z = lerp_angle(weapon_handler.rotation.z, \
			deg_to_rad(5), 0.05)
	else:
		weapon_handler.rotation.z = lerp_angle(weapon_handler.rotation.z, \
			deg_to_rad(0), 0.05)


func _weapon_sway() -> void:
	var delta_time := get_process_delta_time() as float
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10 * delta_time)
	
	weapon_handler.rotation.x = lerp(weapon_handler.rotation.x, \
		mouse_input.y * weapon_rotation, 10 * delta_time)
	weapon_handler.rotation.y = lerp(weapon_handler.rotation.y, \
		mouse_input.x * weapon_rotation, 10 * delta_time)


func _head_bob() -> void:
	headbob_time += get_physics_process_delta_time() * velocity.length() * float(is_on_floor())
	
	var headbob_position = Vector3.ZERO
	headbob_position.y = sin(headbob_time * headbob_frequency) * headbob_amplitude
	headbob_position.x = cos(headbob_time * headbob_frequency / 2 ) * headbob_amplitude
	
	view_container.transform.origin = headbob_position
