@icon("icon.svg")
@tool
class_name Billboard
extends Node3D


const PIXEL_LENGHT := 0.005

@export var mesh_scale: float = 1.0: set = _export_set_mesh_scale

var quad_size: Vector2 = Vector2.ONE

var quad_mesh := QuadMesh.new()
var mesh_instance_3d := MeshInstance3D.new()


func _init() -> void:
	mesh_instance_3d.mesh = quad_mesh
	add_child(mesh_instance_3d)


func _export_set_mesh_scale(s: float) -> void:
	mesh_scale = s
	quad_mesh.size = PIXEL_LENGHT * mesh_scale * quad_size


func set_material(material: Material) -> void:
	quad_mesh.material = material


func get_material() -> Material:
	return quad_mesh.material


func set_size(size: Vector2) -> void:
	quad_size = size
	quad_mesh.size = PIXEL_LENGHT * mesh_scale * quad_size


func get_size() -> Vector2:
	return quad_mesh.size
