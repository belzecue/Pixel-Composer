//Inigo Quilez 
//Oh where would I be without you.

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

const int MAX_MARCHING_STEPS = 512;
const float EPSILON = 1e-6;
const float PI = 3.14159265358979323846;

uniform vec3  position;
uniform vec3  rotation;
uniform float objectScale;

uniform float fov;
uniform vec2  viewRange;

uniform int   type;
uniform float density;
uniform int   iteration;
uniform float threshold;

uniform int   adaptiveIteration;
uniform float detailScale;
uniform float detailAtten;

mat3 rotMatrix, irotMatrix;
vec3 eye, dir;

#region ////========== Transform ============
    mat3 rotateX(float dg) {
        float c = cos(radians(dg));
        float s = sin(radians(dg));
        return mat3(
            vec3(1, 0,  0),
            vec3(0, c, -s),
            vec3(0, s,  c)
        );
    }
    
    mat3 rotateY(float dg) {
        float c = cos(radians(dg));
        float s = sin(radians(dg));
        return mat3(
            vec3( c, 0, s),
            vec3( 0, 1, 0),
            vec3(-s, 0, c)
        );
    }
    
    mat3 rotateZ(float dg) {
        float c = cos(radians(dg));
        float s = sin(radians(dg));
        return mat3(
            vec3(c, -s, 0),
            vec3(s,  c, 0),
            vec3(0,  0, 1)
        );
    }
    
    mat3 inverse(mat3 m) {
        float a00 = m[0][0], a01 = m[0][1], a02 = m[0][2];
        float a10 = m[1][0], a11 = m[1][1], a12 = m[1][2];
        float a20 = m[2][0], a21 = m[2][1], a22 = m[2][2];
        
        float b01 = a22 * a11 - a12 * a21;
        float b11 = -a22 * a10 + a12 * a20;
        float b21 = a21 * a10 - a11 * a20;
        
        float det = a00 * b01 + a01 * b11 + a02 * b21;
        
        return mat3(b01, (-a22 * a01 + a02 * a21), (a12 * a01 - a02 * a11),
                  b11, (a22 * a00 - a02 * a20), (-a12 * a00 + a02 * a10),
                  b21, (-a21 * a00 + a01 * a20), (a11 * a00 - a01 * a10)) / det;
    }
#endregion

#region ////============= Noise ==============
	
	vec3 mod289(vec3 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
	vec4 mod289(vec4 x) { return x - floor(x * (1.0 / 289.0)) * 289.0; }
	vec4 permute(vec4 x) { return mod289(((x * 34.0) + 10.0) * x); }
	vec4 taylorInvSqrt(vec4 r) { return 1.79284291400159 - 0.85373472095314 * r; }

	float snoise(vec3 vec) {
		vec3 v = vec * 4.;
		
		const vec2 C = vec2(1.0 / 6.0, 1.0 / 3.0);
		const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
	
		// First corner
		vec3 i  = floor(v + dot(v, C.yyy));
		vec3 x0 =   v - i + dot(i, C.xxx);
	
		// Other corners
		vec3 g = step(x0.yzx, x0.xyz);
		vec3 l = 1.0 - g;
		vec3 i1 = min( g.xyz, l.zxy );
		vec3 i2 = max( g.xyz, l.zxy );
		
		//   x0 = x0 - 0.0 + 0.0 * C.xxx;
		//   x1 = x0 - i1  + 1.0 * C.xxx;
		//   x2 = x0 - i2  + 2.0 * C.xxx;
		//   x3 = x0 - 1.0 + 3.0 * C.xxx;
		vec3 x1 = x0 - i1 + C.xxx;
		vec3 x2 = x0 - i2 + C.yyy; // 2.0*C.x = 1/3 = C.y
		vec3 x3 = x0 - D.yyy;      // -1.0+3.0*C.x = -0.5 = -D.y
	
		// Permutations
		i = mod289(i); 
		vec4 p = permute( permute( permute( 
	             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
	           + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
	           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));
	
		// Gradients: 7x7 points over a square, mapped onto an octahedron.
		// The ring size 17*17 = 289 is close to a multiple of 49 (49*6 = 294)
		float n_ = 0.142857142857; // 1.0/7.0
		vec3  ns = n_ * D.wyz - D.xzx;
		
		vec4 j = p - 49.0 * floor(p * ns.z * ns.z);  //  mod(p,7*7)
		
		vec4 x_ = floor(j * ns.z);
		vec4 y_ = floor(j - 7.0 * x_ );    // mod(j,N)
		
		vec4 x = x_ * ns.x + ns.yyyy;
		vec4 y = y_ * ns.x + ns.yyyy;
		vec4 h = 1.0 - abs(x) - abs(y);
		
		vec4 b0 = vec4( x.xy, y.xy );
		vec4 b1 = vec4( x.zw, y.zw );
		
		//vec4 s0 = vec4(lessThan(b0,0.0))*2.0 - 1.0;
		//vec4 s1 = vec4(lessThan(b1,0.0))*2.0 - 1.0;
		vec4 s0 = floor(b0) * 2.0 + 1.0;
		vec4 s1 = floor(b1) * 2.0 + 1.0;
		vec4 sh = -step(h, vec4(0.0));
		
		vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy ;
		vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww ;
		
		vec3 p0 = vec3(a0.xy, h.x);
		vec3 p1 = vec3(a0.zw, h.y);
		vec3 p2 = vec3(a1.xy, h.z);
		vec3 p3 = vec3(a1.zw, h.w);
	
		//Normalise gradients
		vec4 norm = taylorInvSqrt(vec4(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
		p0 *= norm.x;
		p1 *= norm.y;
		p2 *= norm.z;
		p3 *= norm.w;
	
		// Mix final noise value
		vec4 m = max(0.5 - vec4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), 0.0);
		m = m * m;
		
		float n = 105.0 * dot( m * m, vec4( dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3) ) );
		n = mix(0.0, 0.5 + 0.5 * n, smoothstep(0.0, 0.003, vec.z));
		return n;
	}
	
	float simplex(in vec3 pos, in int itr) {
	    vec3 xyz = vec3(pos);
        xyz.z = abs(xyz.z);
	         
		float amp = 1.;
	    float n   = 0.;
	    float acc = 0.;
		
		for(int i = 0; i < itr; i++) {
			n   += snoise(xyz) * amp;
			acc += amp;
			
			amp *= detailAtten;
			xyz *= detailScale;
		}
		
		return n / acc;
	}

#endregion

float volume(vec3 pos, float ratio) { 
	int   it = adaptiveIteration == 1? int(max(1., ratio * float(iteration))) : iteration;
	float ss = simplex(pos * 0.5, it / 2);
	float sp = simplex(pos, it);
	
	float thr = threshold;
	
	float d1  = clamp(max(0., ss - thr) / (1. - thr), 0., 1.);
	      d1  = smoothstep(.2, .8, d1);
		  d1 *= clamp(1. - distance(pos, eye) / 16., 0., 1.);
		  
	float ds = clamp(max(0., sp - thr) / (1. - thr), 0., 1.);
	
	ds *= d1;
	
		 if(type == 0) return ds;
	else if(type == 1) return smoothstep(-.1, .1, pos.y) * ds;
	
	return 0.;
}

float marchDensity(vec3 camera, vec3 direction) {
	float maxx    = float(MAX_MARCHING_STEPS);
	float st      = 1. / maxx;
	float _densi  = 0.;
	float dens    = pow(2., 10. * density - 10.);
	 
    for (float i = 0.; i <= maxx; i++) {
        float depth = mix(viewRange.x, viewRange.y, i * st);
        vec3  pos   = camera + depth * direction;
        float mden  = volume(pos, 1. - i * st);
        _densi += dens * mden;
    }
    
    return _densi; 
}

void main() {
	mat3 rx = rotateX(rotation.x);
    mat3 ry = rotateY(rotation.y);
    mat3 rz = rotateZ(rotation.z);
    rotMatrix  = rx * ry * rz;
    irotMatrix = inverse(rotMatrix);
	 
    float z = 1. / tan(radians(fov) / 2.);
    dir = normalize(vec3((v_vTexcoord - .5) * 2., -z));
    eye = vec3(0., 0., 5.);
	
	dir  = normalize(irotMatrix * dir) / objectScale;
	eye  = irotMatrix * eye;
	eye /= objectScale;
	eye -= position;
	
    float dens = marchDensity(eye, dir);
    gl_FragColor = vec4(vec3(dens), 1.);
}