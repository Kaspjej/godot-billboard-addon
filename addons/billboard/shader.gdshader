shader_type spatial;
render_mode specular_disabled, depth_prepass_alpha;


uniform sampler2D albedo_texture: source_color, filter_linear, repeat_disable;

uniform bool flip_h = false;
uniform bool flip_v = false;

uniform uint frame = 0u;
uniform uint h_frames = 1u;
uniform uint v_frames = 1u;

uniform uint billboard_mode = 0u;


void vertex() {
	if (billboard_mode == 1u) {
		vec3 global_up = vec3(0.0, 1.0, 0.0);
		vec3 cam_forward = normalize(MAIN_CAM_INV_VIEW_MATRIX[2].xyz);
		vec3 cam_right = normalize(cross(global_up, cam_forward));
		vec3 billboard_forward = normalize(cross(cam_right, global_up));

		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		    vec4(cam_right, 0.0),
		    vec4(global_up, 0.0),
		    vec4(billboard_forward, 0.0),
		    MODEL_MATRIX[3]
		);
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
	else if (billboard_mode == 2u) {
		vec3 forward = normalize(MAIN_CAM_INV_VIEW_MATRIX[2].xyz);
		vec3 up = normalize(MAIN_CAM_INV_VIEW_MATRIX[1].xyz);
		vec3 right = normalize(MAIN_CAM_INV_VIEW_MATRIX[0].xyz);

		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		    vec4(right, 0.0),
		    vec4(up, 0.0),
		    vec4(forward, 0.0),
		    MODEL_MATRIX[3]
		);

		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}

	if (flip_h) {
		UV.x = 1.0f - UV.x;
	}

	if (flip_v) {
		UV.y = 1.0f - UV.y;
	}

	UV.x += float(frame % h_frames);
	UV.y += float(frame / h_frames);

	UV.x /= float(h_frames);
	UV.y /= float(v_frames);
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);

	ALBEDO = tex.rgb;
	ALPHA = tex.a;
	//NORMAL = vec3(0.0, 1.0, 0.0);
}