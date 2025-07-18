extends CharacterBody3D
class_name Projectile


@export var speed_value_min := 0.0
@export var speed_value_max := 0.0
@export var damage := 0.0
@export var queue_free_timer_value := 1.5

@onready var model := $Model as Sprite3D
@onready var hurtbox := $Hurtbox as Hurtbox
@onready var velocity_3d := $Velocity3d as Velocity3d
@onready var face_direction := $FaceDirection as FaceDirection
@onready var queue_free_timer := $QueueFreeTimer as Timer


func _ready() -> void:
	velocity_3d.max_fast_speed = randf_range(speed_value_min, speed_value_max)
	queue_free_timer.wait_time = queue_free_timer_value
	hurtbox.damage = damage
	
	hurtbox.damage_dealt.connect(queue_free)
	hurtbox.limit_impacted.connect(queue_free)
	queue_free_timer.timeout.connect(queue_free)


func _physics_process(_delta: float) -> void:
	var move_direction := _get_direction()
	velocity_3d.accelerate(move_direction, velocity_3d.max_fast_speed)
	velocity_3d.move(self, false)


func _get_direction() -> Vector3:
	return -face_direction.global_transform.basis.z
