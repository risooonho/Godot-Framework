shader_type canvas_item;

void vertex() {
	VERTEX.x += sin(TIME);
	VERTEX.y *= cos(TIME);
}

void light() {
	LIGHT = vec4(texture(TEXTURE, UV).rgb + sin(cos(TIME)), 1.0);
}