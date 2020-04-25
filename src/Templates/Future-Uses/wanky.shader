shader_type canvas_item;

void vertex() {
	VERTEX.x *= sin(TIME * 2.1);
	VERTEX.y += cos(TIME / 4.0);

}
void fragment() {
	COLOR = vec4(UV, 0.5, 1.0);
}