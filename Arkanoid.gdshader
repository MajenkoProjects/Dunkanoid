shader_type canvas_item;
uniform sampler2D ColourTexture;
uniform vec2 rect_global_position; 
uniform vec2 rect_size;

void vertex() {
}

void fragment() {
//	float b = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
//	COLOR.rgb = texture(ColourTexture, UV).rgb * vec3(b, b, b);

	if ((COLOR.r > 0.8) && (COLOR.g > 0.8) && (COLOR.b < 0.2) && (COLOR.a > 0.9)) {
		vec2 actual_uv = (SCREEN_UV - rect_global_position) * rect_size;
		COLOR.rgb = texture(ColourTexture, actual_uv).rgb ;
	}
//	if (COLOR.rgba == vec4(1.0, 0.0, 1.0, 1.0)) {
//	if (COLOR.a > 0.9) {
//		COLOR.rgb = texture(ColourTexture, UV).rgb;
//		COLOR.rgb = vec3(UV.y * 8.0, UV.y * 6.0, 1.0 - (UV.y * 14.0));
//		COLOR.rgb = vec3(UV.x, UV.x, UV.x);
//	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
