shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 screen_size = vec2(1920.0, 1080.0); // set to your actual viewport size, or pass from script

uniform float speed : hint_range(0.0, 5.0) = 0.5;
uniform float intensity : hint_range(0.0, 1.0) = 0.0;
uniform vec4 sand_color : source_color = vec4(0.75, 0.45, 0.05, 1.0);
uniform float noise_scale : hint_range(1.0, 50.0) = 8.0;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.25;

uniform vec2 player_screen_pos = vec2(0.5, 0.5);
uniform float visibility_radius : hint_range(0.0, 1.0) = 0.18;
uniform float visibility_falloff : hint_range(0.01, 1.0) = 0.25;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 base_color = texture(screen_texture, uv);

    // aspect-corrected uv, so circles stay circular regardless of screen shape
    float aspect = screen_size.x / screen_size.y;
    vec2 aspect_uv = vec2((uv.x - 0.5) * aspect, uv.y - 0.5);

    float time_offset = TIME * speed;
    float n1 = noise(uv * noise_scale - vec2(time_offset, time_offset * 0.3));
    float n2 = noise(uv * noise_scale * 2.3 - vec2(time_offset * 1.6, time_offset * 0.5));
    float combined_noise = n1 * 0.6 + n2 * 0.4;

    // fine grain layer, high frequency, changes every frame for texture/dust noise
    float grain = hash(uv * screen_size + vec2(TIME * 60.0, 0.0));
    combined_noise = mix(combined_noise, grain, grain_amount);

    // circular vignette using aspect-corrected distance
    float dist_from_center = length(aspect_uv);
    float vignette = smoothstep(0.25, 0.7, dist_from_center);

    float storm_amount = clamp((combined_noise * 0.6 + vignette * 0.6) * intensity, 0.0, 1.0);

    // circular clear zone around player, also aspect-corrected
    vec2 player_aspect_pos = vec2((player_screen_pos.x - 0.5) * aspect, player_screen_pos.y - 0.5);
    float dist_from_player = distance(aspect_uv, player_aspect_pos);
    float visibility = smoothstep(visibility_radius, visibility_radius + visibility_falloff, dist_from_player);

    float final_storm = storm_amount * visibility;

    vec3 final_rgb = mix(base_color.rgb, sand_color.rgb, final_storm);
    final_rgb *= mix(1.0, 0.6, storm_amount * visibility);

    COLOR = vec4(final_rgb, 1.0);
}