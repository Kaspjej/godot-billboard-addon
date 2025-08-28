@tool
class_name SpriteBillboard
extends ShaderBillboard


@export var texture: Texture2D = null: set = _export_set_texture

@export var frame: int = 0: set = _export_set_frame
@export var h_frames: int = 1: set = _export_set_h_frames
@export var v_frames: int = 1: set = _export_set_v_frames


func _export_set_texture(tex: Texture2D) -> void:
	texture = tex
	material.set_shader_parameter(&"albedo_texture", texture)
	update_size()


func _export_set_frame(f: int) -> void:
	frame = max(f, 0) % (h_frames * v_frames)
	material.set_shader_parameter(&"frame", frame)


func _export_set_h_frames(frames: int) -> void:
	h_frames = max(frames, 1)
	material.set_shader_parameter(&"h_frames", h_frames)
	update_size()


func _export_set_v_frames(frames: int) -> void:
	v_frames = max(frames, 1)
	material.set_shader_parameter(&"v_frames", v_frames)
	update_size()


func update_size() -> void:
	if not texture:
		return
	var size = texture.get_size()
	size.x /= h_frames
	size.y /= v_frames
	set_size(size)
