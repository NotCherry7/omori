shader_type canvas_item;

uniform float speed = 0.2;
uniform float view_width = 0.1;

void fragment() {
	vec2 uv = UV;
	float cycle_time = 1.0 / speed;
	float t = mod(TIME, cycle_time) / cycle_time;
	float grow_phase = clamp(t * 5.0, 0.0, 1.0);
	float move_phase = max((t - 0.0) * 1.15, 0.0);

	float dynamic_width = view_width;
	float left_bound = move_phase - dynamic_width;
	float right_bound = left_bound + dynamic_width;
	if (uv.x >= left_bound && uv.x <= right_bound) {
		COLOR = texture(TEXTURE, uv);
	} else {
		COLOR = vec4(0.0);
	}
}