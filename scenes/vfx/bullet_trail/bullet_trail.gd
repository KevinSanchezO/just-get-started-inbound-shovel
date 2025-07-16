extends MeshInstance3D
class_name BulletTrail

@onready var timer := $Timer as Timer

var alpha = 1.0
var difussion_value := 2.5

func _ready() -> void:
	timer.timeout.connect(queue_free)

func _process(delta: float) -> void:
	alpha -= delta * difussion_value
	material_override.albedo_color.a = alpha


func init(origin_pos, reach_pos) -> void:
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	draw_mesh.surface_add_vertex(origin_pos)
	draw_mesh.surface_add_vertex(reach_pos)
	draw_mesh.surface_end()
