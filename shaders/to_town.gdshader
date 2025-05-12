shader_type canvas_item;

uniform float time_between_changes = 1.5;
uniform float distortion_strength = 0.002;

float rand(vec2 co) {
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	float t = floor(TIME / time_between_changes); // change every 1.5s
	vec2 dist_uv = UV;

	// Create slight per-character UV distortion
	float noise = rand(floor(dist_uv * 50.0 + t)); // Change pattern based on time
	dist_uv.x += (noise - 0.5) * distortion_strength;
	dist_uv.y += (noise - 0.5) * distortion_strength;

	COLOR = texture(TEXTURE, dist_uv) * COLOR;
}