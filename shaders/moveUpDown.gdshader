shader_type canvas_item;

uniform float height = 7.0;
uniform float speed = 3.0;

void vertex() {
	VERTEX.y += height * sin(speed * TIME) - height;
}
