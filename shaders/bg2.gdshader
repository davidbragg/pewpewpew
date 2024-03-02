shader_type canvas_item;

uniform vec4 new_color: source_color;

void vertex() {
	UV.y -= TIME / 65.0;
}

void fragment() { 
	vec4 curr_color = texture(TEXTURE, UV);
	if (curr_color.a > 0.0) { 
		COLOR.rgb = new_color.rgb;
	}
}