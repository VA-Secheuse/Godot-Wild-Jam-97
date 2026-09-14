shader_type canvas_item;

uniform float alpha_amount : hint_range(0.0, 1.0) = 0.5;   
uniform float invalid_amount : hint_range(0.0, 1.0) = 0.5; 
uniform vec4 invalid_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); 

void fragment() {
    vec4 input_color = texture(TEXTURE, UV);

    // blend original color toward the invalid (red) color based on invalid_amount
    vec3 tinted_rgb = mix(input_color.rgb, invalid_color.rgb, invalid_amount);

    COLOR = vec4(tinted_rgb, input_color.a * alpha_amount);
}