//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 dimension;
uniform int tile_type;

uniform int useMask;
uniform int preserveAlpha;
uniform sampler2D mask;
uniform sampler2D fore;
uniform float opacity;

float sampleMask() {
	if(useMask == 0) return 1.;
	vec4 m = texture2D( mask, v_vTexcoord );
	return (m.r + m.g + m.b) / 3. * m.a;
}

vec4 maxx(vec4 a, vec4 b) { return vec4(max(a.r, b.r), max(a.g, b.g), max(a.b, b.b), max(a.a, b.a)); }
vec4 minn(vec4 a, vec4 b) { return vec4(min(a.r, b.r), min(a.g, b.g), min(a.b, b.b), min(a.a, b.a)); }

void main() {
	vec4 _col0 = texture2D( gm_BaseTexture, v_vTexcoord );
	vec2 _frtx = tile_type == 1? fract(v_vTexcoord * dimension) : v_vTexcoord;
	vec4 _col1 = texture2D( fore, _frtx );
	_col1.a   *= opacity * sampleMask();
	
	vec4 base  = _col0 * (1. - opacity);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		float lum   = dot(_col1.rgb, vec3(0.2126, 0.7152, 0.0722));
		vec4  blend = lum > .5? maxx(_col0, 2. * (_col1 - .5)) : minn(_col0, 2. * _col1);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	vec4  mx  = base + blend * opacity;
	float po  = preserveAlpha == 1? _col1.a : opacity;
	float al  = _col1.a + _col0.a * (1. - _col1.a);
	vec4  res = mix(_col0, mx, po);
	
	res.rgb /= al;
	res.a = preserveAlpha == 1? _col0.a : res.a;
	
    gl_FragColor = res;
}
