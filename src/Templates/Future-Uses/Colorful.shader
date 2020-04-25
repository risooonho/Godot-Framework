shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV + -vec2(TIME, TIME) * 0.5) + vec4(0.0, UV, sin(TIME) + 0.8);
}