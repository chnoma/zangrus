shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec3 color = vec3(1.0, 1.0, 1.0);

void fragment() {
	vec4 og_color = textureLod(screen_texture, SCREEN_UV, 0.0);
    COLOR = vec4(og_color.r*color.r, og_color.g*color.g, og_color.b*color.b, 1.0);
}