shader_type canvas_item;

uniform float build_progress : hint_range(0.0, 1.0) = 0.0; // 0 = not built, 1 = fully built
uniform vec4 line_color : source_color = vec4(0.3, 0.7, 1.0, 1.0); // blue glint
uniform float line_thickness : hint_range(0.0, 0.2) = 0.1;

void fragment() {
    vec4 input_color = texture(TEXTURE, UV);

    // UV.y = 0 is top, 1 is bottom in Godot, so invert so progress fills bottom -> top
    float reveal_y = 1.0 - build_progress;

    // below the reveal line: draw normally. above it: fully transparent (not built yet)
    float visible = step(reveal_y, UV.y);

    // distance from the current pixel to the reveal line, for the glint
    float dist_to_line = abs(UV.y - reveal_y);
    float glint = 1.0 - smoothstep(0.0, line_thickness, dist_to_line);

    vec3 final_rgb = mix(input_color.rgb, line_color.rgb, glint);
    float final_alpha = input_color.a * max(visible, glint);

    COLOR = vec4(final_rgb, final_alpha);
}