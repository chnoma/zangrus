shader_type canvas_item;

uniform sampler2D screen_texture : source_color, hint_screen_texture;

void vertex() {
  //POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	float b = texture(screen_texture, SCREEN_UV).x;
	COLOR = vec4(0.4, 0.6, 0.9, 1.0);
}