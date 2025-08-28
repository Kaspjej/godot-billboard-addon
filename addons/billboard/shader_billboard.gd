class_name ShaderBillboard
extends Billboard


enum BillboardMode {
	DISABLED,
	Y_ONLY,
	ENABLED
}

const SHADER := preload("shader.gdshader")

@export var flip_h: bool = false: set = _export_set_flip_h
@export var flip_v: bool = false: set = _export_set_flip_v
@export var billboard_mode: BillboardMode = BillboardMode.DISABLED: set = _export_set_billboard_mode

var material := ShaderMaterial.new()


func _init() -> void:
	super()
	material.shader = SHADER
	set_material(material)


func _export_set_flip_h(flip: bool) -> void:
	flip_h = flip
	material.set_shader_parameter(&"flip_h", flip_h)


func _export_set_flip_v(flip: bool) -> void:
	flip_v = flip
	material.set_shader_parameter(&"flip_v", flip_v)


func _export_set_billboard_mode(mode: BillboardMode) -> void:
	billboard_mode = mode
	material.set_shader_parameter(&"billboard_mode", billboard_mode)
