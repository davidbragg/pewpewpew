shader_type canvas_item;

uniform vec4 new_color : source_color;

void fragment() {
	vec3 black = vec3(3.0, 3.0, 3.0);
	vec4 curr_color = texture(TEXTURE, UV);
	if (curr_color.a > 0.0 && curr_color.r > 0.2) {
		COLOR.rgb = new_color.rgb;
	}
}
