shader_type canvas_item;

void vertex() {
	VERTEX.y -= 7.0 * sin(3.0 * TIME) - 7.0;
}
