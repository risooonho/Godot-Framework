shader_type canvas_item;

uniform float SCALE = 2.0;
uniform float OFFSET_SCALE = 0.2;
//void vertex() {
//	VERTEX += vec2(sin(TIME) + tan(UV.x * sin(TIME)), cos(TIME)) * vec2(50.0);
//	VERTEX.y += cos(TIME);
//}

void fragment() {
	float col_x;
	vec2 col_y;
	float step = 4.0;
	
	// COLOR = vec4(UV, 0.5, sin(TIME * 2.0));
	if (UV.x > 0.5) {
		col_x = UV.x;
	} else {
		col_x = UV.y;
	}
	if (UV.y > 0.5) {
		col_y = sin(UV * TIME);
	} else {
		col_y = cos(UV * TIME);
	}
	COLOR = vec4(col_x / (sin(UV.x)* sin(TIME)), col_y * sin(UV.y), 1.0) / texture(TEXTURE, UV);
	COLOR = sin(vec4(TIME, TIME, TIME, 1.0) + texture(TEXTURE, UV));
//	if (texture(TEXTURE, UV).rgb != vec3(0.0)) {
//		COLOR = texture(TEXTURE, sin(UV + sin(TIME)) * OFFSET_SCALE) + vec4(0.0, UV.y * OFFSET_SCALE, UV.y, 0.1) + vec4(0.0, col_y.g * OFFSET_SCALE, col_y.y * sin(UV.y), 1.0);
//	}
}