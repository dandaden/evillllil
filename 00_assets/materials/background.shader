shader_type canvas_item;

uniform vec2 tile_factor = vec2(10.0,10.0);
uniform float ratio = 0.5;
uniform float wobble = 0.05;

void fragment() {
	vec2 tiled_uvs = UV * tile_factor;
	tiled_uvs.y *= ratio;
	
	vec2 waves;
	waves.x = cos(TIME + tiled_uvs.y + tiled_uvs.x) + (TIME*2.0);
	waves.y = sin(TIME + tiled_uvs.x)  + (TIME*2.0);
	
	COLOR = texture( TEXTURE, tiled_uvs + waves * wobble);
}