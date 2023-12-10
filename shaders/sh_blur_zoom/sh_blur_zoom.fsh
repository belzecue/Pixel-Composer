//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float strength;
uniform vec2  center;
uniform int   sampleMode;
uniform int   blurMode;

uniform int useMask;
uniform sampler2D mask;

#region ==== PARAM DRIVER ====
	#define PARAM_COUNT 1
	uniform int       parameter_active[PARAM_COUNT];
	uniform sampler2D parameters;

	float sampleParameter(in int index, in float def) {
		if(parameter_active[index] == 0) return def;
		float row  = floor(float(index) / 4.);
		vec2 coord = (v_vTexcoord + vec2(float(index) - row * 4., row)) * 0.25;
		vec4 col = texture2D( parameters, coord );
		
		float _val = col.r;
		float _min = col.g * 256. - 128.;
		float _max = col.b * 256. - 128.;
		
		return mix(_min, _max, _val);
	}
#endregion

float sampleMask() { #region
	if(useMask == 0) return 1.;
	vec4 m = texture2D( mask, v_vTexcoord );
	return (m.r + m.g + m.b) / 3. * m.a;
} #endregion

vec4 sampleTexture(vec2 pos) { #region
	if(pos.x >= 0. && pos.y >= 0. && pos.x <= 1. && pos.y <= 1.)
		return texture2D(gm_BaseTexture, pos);
	
	if(sampleMode == 0) 
		return vec4(0.);
	if(sampleMode == 1) 
		return texture2D(gm_BaseTexture, clamp(pos, 0., 1.));
	if(sampleMode == 2) 
		return texture2D(gm_BaseTexture, fract(pos));
	
	return vec4(0.);
} #endregion

void main() { #region
    vec2 uv = v_vTexcoord - center;
	
	float str = sampleParameter(0, strength) * sampleMask();
	float nsamples = 64.;
	float scale_factor = str * (1. / (nsamples * 2. - 1.));
	vec4  color = vec4(0.0);
    float blrStart = 0.;
	
	if(blurMode == 0)		blrStart = 0.;
	else if(blurMode == 1)	blrStart = -nsamples;
	else if(blurMode == 2)	blrStart = -nsamples * 2. - 1.;
	
    for(float i = 0.; i < nsamples * 2. + 1.; i++) {
        float scale = 1.0 + ((blrStart + i) * scale_factor);
		vec2 pos = uv * scale + center;
		color += sampleTexture(pos);
    }
    
    color /= nsamples * 2. + 1.;
    
	gl_FragColor = color;
} #endregion