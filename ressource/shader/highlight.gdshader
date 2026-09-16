shader_type canvas_item;

uniform vec4 highlight_color : source_color = vec4(0.2, 0.7, 1.0, 1.0);
uniform float highlight_strength : hint_range(0.0, 1.0) = 0.5;
uniform float outline_size : hint_range(0.0, 10.0) = 2.0;
uniform bool use_outline = true;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Blend the original texture with the highlight color
    vec3 highlighted = mix(
        tex.rgb,
        highlight_color.rgb,
        highlight_strength
    );

    COLOR = vec4(highlighted, tex.a);

    // Optional outline around the texture
    if (use_outline && tex.a < 0.1) {
        float alpha = 0.0;

        vec2 pixel_size = TEXTURE_PIXEL_SIZE * outline_size;

        alpha += texture(TEXTURE, UV + vec2(pixel_size.x, 0.0)).a;
        alpha += texture(TEXTURE, UV + vec2(-pixel_size.x, 0.0)).a;
        alpha += texture(TEXTURE, UV + vec2(0.0, pixel_size.y)).a;
        alpha += texture(TEXTURE, UV + vec2(0.0, -pixel_size.y)).a;

        if (alpha > 0.1) {
            COLOR = vec4(highlight_color.rgb, highlight_color.a);
        }
    }
}