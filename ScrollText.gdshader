shader_type canvas_item;
uniform sampler2D ColourTexture;
uniform vec2 rect_global_position; 
uniform vec2 rect_size;

void vertex() {
}

void fragment() {
	vec2 actual_uv = (SCREEN_UV - rect_global_position) * rect_size;
	COLOR *= texture(ColourTexture, actual_uv);
}

