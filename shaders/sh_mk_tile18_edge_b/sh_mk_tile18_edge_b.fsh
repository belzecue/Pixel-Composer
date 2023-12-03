//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 dimension;
uniform vec4 crop;
uniform int edge;

void main() {
	float  w = dimension.x;
	float  h = dimension.y;
	
	vec2  tx = v_vTexcoord * dimension;
	gl_FragColor = vec4(0.);
	
	if(edge == 2) {
		if(tx.x < w - tx.y) discard;
		
	} else if(edge == 3) {
		
	} else if(edge == 1) {
		if(tx.x > tx.y) discard;
		
	} else if(edge == 7) {
		if(tx.x + crop[2] < tx.y + crop[1]) discard;
		
	} else if(edge == 11) {
		if(tx.x - crop[0] > h - tx.y - crop[3]) discard;
		
	} else if(edge ==  9) {
		if(tx.x + crop[2] > tx.y + crop[3]) discard;
		
	} else if(edge ==  6) {
		if(tx.x - crop[0] < h - tx.y - crop[1]) discard;
		
	} else {
		discard;
	}
	
	gl_FragColor = texture2D( gm_BaseTexture, v_vTexcoord );
}
