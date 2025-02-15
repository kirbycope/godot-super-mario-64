shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 center = vec2(0.5, 0.5);
uniform float smoothness : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    // Convert UV to centered coordinates
    vec2 uv = UV - center;
    
    // Calculate distance from center
    float dist = length(uv);
    
    // Create smooth circle transition
    // Multiply by 2 to make the circle expand from center to corners
    float circle = smoothstep(progress * 2.0, progress * 2.0 + smoothness, dist);
    
    // Output the alpha value
    COLOR = vec4(0.0, 0.0, 0.0, circle);
}