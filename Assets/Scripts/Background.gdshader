shader_type canvas_item;

uniform float tile_count = 4.0; // Number of times the texture repeats
uniform float rotation_randomness : hint_range(0.0, 1.0) = 1.0;

// Simple hash function to generate a random float from a vec2
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D Rotation Matrix
mat2 rotate2d(float angle) {
    return mat2(vec2(cos(angle), -sin(angle)),
                vec2(sin(angle), cos(angle)));
}

void fragment() {
    // 1. Scale UVs to create tiling
    vec2 tiled_uv = UV * tile_count;

    // 2. Identify the current tile "cell"
    vec2 cell_id = floor(tiled_uv);

    // 3. Get a random angle for this specific cell (0 to TAU)
    float random_val = hash(cell_id);
    float angle = random_val * 6.283185 * rotation_randomness;

    // 4. Transform UVs within the [0, 1] range of the tile
    vec2 local_uv = fract(tiled_uv);

    // 5. Rotate around the center of the tile (0.5, 0.5)
    local_uv -= 0.5;
    local_uv = rotate2d(angle) * local_uv;
    local_uv += 0.5;

    // 6. Sample the texture
    // Ensure "Repeat" is enabled in the Texture settings for the TextureRect
    COLOR = texture(TEXTURE, local_uv);
}