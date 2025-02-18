shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

float starShape(vec2 p) {
    // Five points of a star at 72-degree intervals
    vec2 points[10];
    float outer_radius = progress * 3.0;
    float inner_radius = outer_radius * 0.5;
    
    for(int i = 0; i < 10; i++) {
        float angle = float(i) * PI / 5.0 - PI / 2.0;
        float radius = (i % 2 == 0) ? outer_radius : inner_radius;
        points[i] = vec2(cos(angle), sin(angle)) * radius;
    }
    
    // Check if point is inside the star
    int intersections = 0;
    for(int i = 0; i < 10; i++) {
        vec2 a = points[i];
        vec2 b = points[(i + 1) % 10];
        
        // Line test
        vec2 ap = p - a;
        vec2 ab = b - a;
        float t = clamp(dot(ap, ab) / dot(ab, ab), 0.0, 1.0);
        vec2 closest = a + ab * t;
        float dist = length(p - closest);
        
        if(dist < 0.01) return 1.0;
        
        // Ray casting
        if(a.y > b.y) { vec2 temp = a; a = b; b = temp; }
        if(p.y > a.y && p.y <= b.y && cross(vec3(b - a, 0.0), vec3(p - a, 0.0)).z > 0.0) {
            intersections++;
        }
    }
    
    return float(intersections % 2);
}

void fragment() {
    vec2 uv = (UV - 0.5) * 2.0;
    float mask = starShape(uv);
    COLOR = vec4(0.0, 0.0, 0.0, 1.0 - mask);
}