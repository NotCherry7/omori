shader_type canvas_item;

void vertex() {
	VERTEX.x += 3.0 * sin(12.0 * TIME);
}