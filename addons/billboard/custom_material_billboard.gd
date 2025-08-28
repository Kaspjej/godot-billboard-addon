@tool
class_name CustomMaterialBillboard
extends Billboard


@export var material: Material = null: set = _export_set_material
@export var size: Vector2 = Vector2.ONE: set = _export_set_size

@export_tool_button("Get Size From Albedo Texture") var call := _export_set_size_form_albedo_texture



func _export_set_material(mat: Material) -> void:
	material = mat
	set_material(material)


func _export_set_size(s: Vector2) -> void:
	size = s
	set_size(size)


func _export_set_size_form_albedo_texture() -> void:
	if not material:
		return
	
	var albedo_texture
	
	if material is ShaderMaterial:
		albedo_texture = material.get_shader_parameter(&"albedo_texture")
	elif material is StandardMaterial3D:
		albedo_texture = material.albedo_texture
	
	if albedo_texture and albedo_texture is Texture2D:
		size = albedo_texture.get_size()
