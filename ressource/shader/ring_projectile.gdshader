shader_type canvas_item;

uniform float ring_radius_px : hint_range(0.0, 1000.0) = 100.0;
uniform float ring_thickness_px : hint_range(0.0, 100.0) = 15.0;
uniform vec4 ring_color : source_color = vec4(1.0, 0.5, 0.2, 1.0);
uniform float fade_out : hint_range(0.0, 1.0) = 1.0;
uniform vec2 node_size_px = vec2(600.0, 600.0);

void fragment() {
	vec2 centered_uv = (UV - vec2(0.5)) * node_size_px;
	float dist = length(centered_uv);

	float ring = smoothstep(ring_radius_px - ring_thickness_px, ring_radius_px, dist) -
	             smoothstep(ring_radius_px, ring_radius_px + ring_thickness_px, dist);

	COLOR = ring_color;
	COLOR.a *= ring * fade_out;
}