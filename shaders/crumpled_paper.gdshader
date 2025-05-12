shader_type canvas_item;

uniform float update_interval = 1.5;
uniform float noise_scale = 200.0;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    float t = floor(TIME / update_interval); // Updates every 1.5 seconds
    vec2 uv = UV * noise_scale;

    // Change pattern based on time by offsetting the UVs
    uv += vec2(t);

    float r = random(uv);

    // Black or dark gray (90% black, 10% dark gray for variation)
    COLOR = vec4(vec3(r < 0.9 ? 0.0 : 0.2), 1.0);
}