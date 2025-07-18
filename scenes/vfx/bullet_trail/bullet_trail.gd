extends MeshInstance3D
class_name BulletTrail

@onready var timer := $Timer as Timer
var alpha = 1.0
var difussion_value := 2.5
var pool: ObjectPool

func _ready() -> void:
	timer.timeout.connect(_return_to_pool)

func _process(delta: float) -> void:
	alpha -= delta * difussion_value
	if material_override:
		material_override.albedo_color.a = alpha

func init(origin_pos: Vector3, reach_pos: Vector3, pool_ref: ObjectPool) -> void:
	pool = pool_ref
	alpha = 1.0
	visible = true
	
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	draw_mesh.surface_add_vertex(origin_pos)
	draw_mesh.surface_add_vertex(reach_pos)
	draw_mesh.surface_end()

	timer.start()

func _return_to_pool():
	pool.return_instance(self)
