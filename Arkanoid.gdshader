shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (COLOR.rgba == vec4(1.0, 0.0, 1.0, 1.0)) {
		COLOR.rgb = vec3(UV.y * 8.0, UV.y * 6.0, 1.0 - (UV.y * 14.0));
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
