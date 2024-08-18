shader_type canvas_item;
render_mode blend_add;

uniform sampler2D gradient;
uniform float flicker_speed = 10.0f;

void fragment()
{
	COLOR.rgb = texture(gradient, vec2(fract(TIME * flicker_speed), 0.0)).rgb;
}