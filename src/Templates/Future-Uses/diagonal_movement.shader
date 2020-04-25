shader_type canvas_item;

uniform float scale_movement = 0.05;
uniform float scale_alpha = 0.05;
uniform float transparency = 1.0;

void fragment() {
//	COLOR = vec4(texture(TEXTURE, UV + TIME * scale_movement).rgb, sin(transparency + TIME) * scale_alpha);
//	COLOR = vec4(texture(TEXTURE, UV).rgb, 1.0);
	COLOR = texture(TEXTURE, UV + -vec2(TIME, TIME) * scale_movement) + vec4(0.0, 0.0, 0.0, 1.0);
}