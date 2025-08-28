@tool
class_name SubViewportBillboard
extends ShaderBillboard


@export var packed_scene: PackedScene = null: set = _export_set_packed_scene
@export var resolution: Vector2i = Vector2i(512, 512): set = _export_set_resolution
@export var resolution_scale: float = 1.0: set = _export_set_resolution_scale
@export var offset: Vector2 = Vector2.ZERO: set = _export_set_offset
@export var centered: bool = false: set = _export_set_centerd

var scene: Node2D

var animation_player: AnimationPlayer

var sub_viewport := SubViewport.new()


func _init() -> void:
	super()
	sub_viewport.disable_3d = true
	sub_viewport.transparent_bg = true


func _enter_tree() -> void:
	add_child(sub_viewport)
	material.set_shader_parameter(&"albedo_texture", sub_viewport.get_texture())


func _export_set_packed_scene(packed: PackedScene) -> void:
	if animation_player and animation_player.current_animation_changed.is_connected(_on_animation_player_current_animation_changed):
		animation_player.current_animation_changed.disconnect(_on_animation_player_current_animation_changed)

	animation_player = null
	packed_scene = null
	scene = null
	
	for child in sub_viewport.get_children(true):
		child.queue_free()
	
	var instantiated_scene = packed.instantiate()
	if not instantiated_scene is Node2D:
		return
	
	packed_scene = packed
	scene = instantiated_scene
	
	sub_viewport.add_child(scene)
	
	update_transforms()
	update_sub_viewport()

	for node in scene.get_children(true):
		if node is AnimationPlayer:
			animation_player = node
			break
	
	if animation_player:
		animation_player.current_animation_changed.connect(_on_animation_player_current_animation_changed)


func _export_set_resolution(res: Vector2i) -> void:
	resolution = res
	update_transforms()
	update_sub_viewport()


func _export_set_resolution_scale(s: float) -> void:
	resolution_scale = max(s, 0.001)
	update_transforms()
	update_sub_viewport()


func _export_set_offset(off: Vector2) -> void:
	offset = off
	update_transforms()
	update_sub_viewport()


func _export_set_centerd(cen: bool) -> void:
	centered = cen
	update_transforms()
	update_sub_viewport()


func _on_animation_player_current_animation_changed(animation_name: String) -> void:
	if animation_name.is_empty():
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	else:
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_WHEN_PARENT_VISIBLE


func update_transforms() -> void:
	sub_viewport.size = resolution_scale * resolution
	
	set_size(resolution)
	
	if not scene:
		return
	
	scene.position = offset / PIXEL_LENGHT
	if centered:
		scene.position += 0.5 * resolution
	scene.position *= resolution_scale
	scene.scale = resolution_scale * Vector2.ONE


func get_sprite(node_path: NodePath) -> Sprite2D:
	if not scene:
		return null
	
	return scene.get_node_or_null(node_path) as Sprite2D


func set_sprite_texture(node_path: NodePath, texture: Texture) -> void:
	var node := get_sprite(node_path)
	if not node: return
	node.set(&"texture", texture)
	update_sub_viewport()


func get_sprite_texture(node_path: NodePath) -> Texture:
	var node := get_sprite(node_path)
	if not node:
		return null
	return node.get(&"texture") as Texture


func update_sub_viewport() -> void:
	if sub_viewport.render_target_update_mode == SubViewport.UPDATE_DISABLED:
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
