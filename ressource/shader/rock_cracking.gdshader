shader_type canvas_item;

uniform float crack_amount : hint_range(0.0, 1.0) = 0.0;
uniform float cell_scale : hint_range(1.0, 50.0) = 12.0;
uniform float crack_thickness : hint_range(0.001, 0.2) = 0.05;
uniform vec4 crack_color : source_color = vec4(0.05, 0.03, 0.02, 1.0);
uniform float seed : hint_range(0.0, 100.0) = 0.0;

uniform vec2 texture_pixel_size = vec2(0.03125, 0.03125); // = 1.0 / 32.0 // 1 / sprite's pixel dimensions, set from script or match your sprite size
uniform float pixel_scale : hint_range(1.0, 8.0) = 1.0; // snap cracks to a coarser grid for a chunkier pixel look

vec2 hash2(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return fract(sin(p + seed) * 43758.5453);
}

float voronoi_edge(vec2 uv) {
    vec2 cell = floor(uv);
    vec2 local = fract(uv);

    float min_dist1 = 8.0;
    float min_dist2 = 8.0;

    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = hash2(cell + neighbor);
            vec2 diff = neighbor + point - local;
            float dist = length(diff);

            if (dist < min_dist1) {
                min_dist2 = min_dist1;
                min_dist1 = dist;
            } else if (dist < min_dist2) {
                min_dist2 = dist;
            }
        }
    }

    return min_dist2 - min_dist1;
}

void fragment() {
    vec4 input_color = texture(TEXTURE, UV);

    // snap UV to the sprite's actual pixel grid (scaled by pixel_scale for chunkier cracks)
    vec2 pixel_size = texture_pixel_size * pixel_scale;
    vec2 snapped_uv = floor(UV / pixel_size) * pixel_size;

    float edge = voronoi_edge(snapped_uv * cell_scale);

    // hard cutoff instead of smoothstep, so edges are crisp, not blurred
    float crack_line = step(edge, crack_thickness);

    vec2 cell_id = floor(snapped_uv * cell_scale);
    float cell_random = hash2(cell_id).x;
    float cell_active = step(cell_random, crack_amount);

    float final_crack = crack_line * cell_active;

    vec3 final_rgb = mix(input_color.rgb, crack_color.rgb, final_crack);
    COLOR = vec4(final_rgb, input_color.a);
}