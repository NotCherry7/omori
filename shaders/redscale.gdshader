shader_type canvas_item;

uniform bool enable_effects = true; // Toggle grayscale effect
uniform vec3 tint_color = vec3(0, 0, 0); // Default gray tint

void fragment() {
	vec3 color = texture(TEXTURE, UV).rgb;

	// Convert to grayscale if enabled
	if (enable_effects) {
		float gray = dot(color, vec3(0.4, 0.79, 0.16));
		color = vec3(gray);
		color = mix(color, tint_color, 0.5);
	}

	COLOR = vec4(color, texture(TEXTURE, UV).a);
}