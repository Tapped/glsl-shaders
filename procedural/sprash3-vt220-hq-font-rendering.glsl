#version 120
// Compatibility #ifdefs needed for parameters
#ifdef GL_ES
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif

// Parameter lines go here:
#pragma parameter RETRO_PIXEL_SIZE "Retro Pixel Size" 0.84 0.0 1.0 0.01
#ifdef PARAMETER_UNIFORM
// All parameter floats need to have COMPAT_PRECISION in front of them
uniform COMPAT_PRECISION float RETRO_PIXEL_SIZE;
#else
#define RETRO_PIXEL_SIZE 0.84
#endif

#if defined(VERTEX)

#if __VERSION__ >= 130
#define COMPAT_VARYING out
#define COMPAT_ATTRIBUTE in
#define COMPAT_TEXTURE texture
#else
#define COMPAT_VARYING varying 
#define COMPAT_ATTRIBUTE attribute 
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif

COMPAT_ATTRIBUTE vec4 VertexCoord;
COMPAT_ATTRIBUTE vec4 COLOR;
COMPAT_ATTRIBUTE vec4 TexCoord;
COMPAT_VARYING vec4 COL0;
COMPAT_VARYING vec4 TEX0;
// out variables go here as COMPAT_VARYING whatever

vec4 _oPosition1; 
uniform mat4 MVPMatrix;
uniform COMPAT_PRECISION int FrameDirection;
uniform COMPAT_PRECISION int FrameCount;
uniform COMPAT_PRECISION vec2 OutputSize;
uniform COMPAT_PRECISION vec2 TextureSize;
uniform COMPAT_PRECISION vec2 InputSize;

// compatibility #defines
#define vTexCoord TEX0.xy
#define SourceSize vec4(TextureSize, 1.0 / TextureSize) //either TextureSize or InputSize
#define OutSize vec4(OutputSize, 1.0 / OutputSize)

void main()
{
    gl_Position = MVPMatrix * VertexCoord;
    TEX0.xy = VertexCoord.xy;
// Paste vertex contents here:
}

#elif defined(FRAGMENT)

#if __VERSION__ >= 130
#define COMPAT_VARYING in
#define COMPAT_TEXTURE texture
out vec4 FragColor;
#else
#define COMPAT_VARYING varying
#define FragColor gl_FragColor
#define COMPAT_TEXTURE texture2D
#endif

#ifdef GL_ES
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#define COMPAT_PRECISION mediump
#else
#define COMPAT_PRECISION
#endif

uniform COMPAT_PRECISION int FrameDirection;
uniform COMPAT_PRECISION int FrameCount;
uniform COMPAT_PRECISION vec2 OutputSize;
uniform COMPAT_PRECISION vec2 TextureSize;
uniform COMPAT_PRECISION vec2 InputSize;
uniform sampler2D Texture;
COMPAT_VARYING vec4 TEX0;
// in variables go here as COMPAT_VARYING whatever

// compatibility #defines
#define Source Texture
#define vTexCoord TEX0.xy

#define SourceSize vec4(TextureSize, 1.0 / TextureSize) //either TextureSize or InputSize
#define OutSize vec4(OutputSize, 1.0 / OutputSize)

// delete all 'params.' or 'registers.' or whatever in the fragment
float iGlobalTime = float(FrameCount)*0.025;
vec2 iResolution = OutputSize.xy;

// Not really made for real time rendering!
// It is quiet the resource hog.
// Ideas stolen from https://www.shadertoy.com/view/MdfSzr

#define FONT_SIZE vec2(10.,20.)

#define l(y,a,b) roundLine(p, vec2(float(a), float(y)), vec2(float(b), float(y)))
float roundLine(vec2 p, vec2 a, vec2 b) {
  b -=a+vec2(1.0,0.); p -= a;
  return smoothstep(1.1, 0.0,length(p-clamp(dot(p,b)/dot(b,b),0.0,1.0)*b));
}

//Generated from png at http://vt100.net/dec/vt220/glyphs
//enable only a few chars otherwise compiler says "memory is exhausted"
float vt220Font(vec2 p, int c)
{
if(c==0) return 0.0;
//else if(c==0) return ;
//else if(c==1) return l(3,4,6)+ l(5,3,7)+ l(7,2,8)+ l(9,1,9)+ l(11,2,8)+ l(13,3,7)+ l(15,4,6);
//else if(c==2) return l(3,1,3)+ l(3,4,6)+ l(3,7,9)+ l(5,2,4)+ l(5,6,8)+ l(7,1,3)+ l(7,4,6)+ l(7,7,9)+ l(9,2,4)+ l(9,6,8)+ l(11,1,3)+ l(11,4,6)+ l(11,7,9)+ l(13,2,4)+ l(13,6,8)+ l(15,1,3)+ l(15,4,6)+ l(15,7,9);
//else if(c==3) return l(3,1,3)+ l(3,4,6)+ l(5,1,3)+ l(5,4,6)+ l(7,1,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,9)+ l(13,5,7)+ l(15,5,7)+ l(17,5,7)+ l(19,5,7);
//else if(c==4) return l(3,1,6)+ l(5,1,3)+ l(7,1,5)+ l(9,1,3)+ l(11,1,3)+ l(11,4,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,6);
//else if(c==5) return l(3,2,6)+ l(5,1,3)+ l(7,1,3)+ l(9,1,3)+ l(11,2,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,8)+ l(17,4,6)+ l(17,7,9)+ l(19,4,6)+ l(19,7,9);
//else if(c==6) return l(3,1,3)+ l(5,1,3)+ l(7,1,3)+ l(9,1,3)+ l(11,1,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,6);
//else if(c==7) return l(3,3,7)+ l(5,2,4)+ l(5,6,8)+ l(7,3,7);
//else if(c==8) return l(5,4,6)+ l(7,4,6)+ l(9,1,9)+ l(11,4,6)+ l(13,4,6)+ l(15,1,9);
//else if(c==9) return l(3,1,3)+ l(3,5,7)+ l(5,1,4)+ l(5,5,7)+ l(7,1,7)+ l(9,1,3)+ l(9,4,7)+ l(11,1,3)+ l(11,4,7)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,4,9);
//else if(c==10) return l(3,1,3)+ l(3,5,7)+ l(5,1,3)+ l(5,5,7)+ l(7,2,6)+ l(9,2,6)+ l(11,3,9)+ l(13,5,7)+ l(15,5,7)+ l(17,5,7)+ l(19,5,7);
//else if(c==11) return l(1,4,6)+ l(3,4,6)+ l(5,4,6)+ l(7,4,6)+ l(9,1,6);
//else if(c==12) return l(9,1,6)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,4,6);
//else if(c==13) return l(9,4,9)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,4,6);
//else if(c==14) return l(1,4,6)+ l(3,4,6)+ l(5,4,6)+ l(7,4,6)+ l(9,4,9);
//else if(c==15) return l(1,4,6)+ l(3,4,6)+ l(5,4,6)+ l(7,4,6)+ l(9,1,9)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,4,6);
//else if(c==16) return l(1,1,9);
//else if(c==17) return l(5,1,9);
//else if(c==18) return l(9,1,9);
//else if(c==19) return l(13,1,9);
else if(c==20) return l(17,1,9);
//else if(c==21) return l(1,4,6)+ l(3,4,6)+ l(5,4,6)+ l(7,4,6)+ l(9,4,9)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,4,6);
//else if(c==22) return l(1,4,6)+ l(3,4,6)+ l(5,4,6)+ l(7,4,6)+ l(9,1,6)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,4,6);
//else if(c==23) return l(1,4,6)+ l(3,4,6)+ l(5,4,6)+ l(7,4,6)+ l(9,1,9);
//else if(c==24) return l(9,1,9)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,4,6);
//else if(c==25) return l(1,4,6)+ l(3,4,6)+ l(5,4,6)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,4,6);
//else if(c==26) return l(3,7,9)+ l(5,5,7)+ l(7,3,5)+ l(9,1,3)+ l(11,3,5)+ l(13,5,7)+ l(15,7,9)+ l(17,1,9);
//else if(c==27) return l(3,1,3)+ l(5,3,5)+ l(7,5,7)+ l(9,7,9)+ l(11,5,7)+ l(13,3,5)+ l(15,1,3)+ l(17,1,9);
//else if(c==28) return l(7,1,9)+ l(9,3,5)+ l(9,6,8)+ l(11,3,5)+ l(11,6,8)+ l(13,3,5)+ l(13,6,8)+ l(15,2,4)+ l(15,6,8);
//else if(c==29) return l(3,7,9)+ l(5,6,8)+ l(7,1,9)+ l(9,4,6)+ l(11,1,9)+ l(13,2,4)+ l(15,1,3);
//else if(c==30) return l(3,4,8)+ l(5,3,5)+ l(5,7,9)+ l(7,3,5)+ l(9,1,7)+ l(11,3,5)+ l(13,2,7)+ l(15,1,5)+ l(15,6,9)+ l(17,2,4);
//else if(c==31) return l(9,4,6);
//else if(c==32) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,2,5)+ l(9,4,6)+ l(11,4,6)+ l(15,4,6);
//else if(c==33) return l(3,4,6)+ l(5,4,6)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(15,4,6);
//else if(c==34) return l(3,2,4)+ l(3,5,7)+ l(5,2,4)+ l(5,5,7)+ l(7,2,4)+ l(7,5,7);
else if(c==35) return l(3,2,4)+ l(3,5,7)+ l(5,2,4)+ l(5,5,7)+ l(7,1,8)+ l(9,2,4)+ l(9,5,7)+ l(11,1,8)+ l(13,2,4)+ l(13,5,7)+ l(15,2,4)+ l(15,5,7);
else if(c==36) return l(3,4,6)+ l(5,2,8)+ l(7,1,3)+ l(7,4,6)+ l(9,2,8)+ l(11,4,6)+ l(11,7,9)+ l(13,2,8)+ l(15,4,6);
else if(c==37) return l(3,2,4)+ l(3,7,9)+ l(5,1,5)+ l(5,6,8)+ l(7,2,4)+ l(7,5,7)+ l(9,4,6)+ l(11,3,5)+ l(11,6,8)+ l(13,2,4)+ l(13,5,9)+ l(15,1,3)+ l(15,6,8);
//else if(c==38) return l(3,2,6)+ l(5,1,3)+ l(5,5,7)+ l(7,1,3)+ l(7,5,7)+ l(9,2,6)+ l(11,1,3)+ l(11,5,9)+ l(13,1,3)+ l(13,6,8)+ l(15,2,9);
//else if(c==39) return l(3,4,7)+ l(5,4,6)+ l(7,3,5);
//else if(c==40) return l(3,5,7)+ l(5,4,6)+ l(7,3,5)+ l(9,3,5)+ l(11,3,5)+ l(13,4,6)+ l(15,5,7);
//else if(c==41) return l(3,3,5)+ l(5,4,6)+ l(7,5,7)+ l(9,5,7)+ l(11,5,7)+ l(13,4,6)+ l(15,3,5);
//else if(c==42) return l(5,2,4)+ l(5,6,8)+ l(7,3,7)+ l(9,1,9)+ l(11,3,7)+ l(13,2,4)+ l(13,6,8);
//else if(c==43) return l(5,4,6)+ l(7,4,6)+ l(9,1,9)+ l(11,4,6)+ l(13,4,6);
//else if(c==44) return l(13,3,6)+ l(15,3,5)+ l(17,2,4);
//else if(c==45) return l(9,1,9);
//else if(c==46) return l(13,3,6)+ l(15,3,6);
//else if(c==47) return l(3,7,9)+ l(5,6,8)+ l(7,5,7)+ l(9,4,6)+ l(11,3,5)+ l(13,2,4)+ l(15,1,3);
//else if(c==48) return l(3,3,7)+ l(5,2,4)+ l(5,6,8)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,2,4)+ l(13,6,8)+ l(15,3,7);
else if(c==49) return l(3,4,6)+ l(5,3,6)+ l(7,2,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
else if(c==50) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,7,9)+ l(9,4,8)+ l(11,2,5)+ l(13,1,3)+ l(15,1,9);
else if(c==51) return l(3,1,9)+ l(5,6,8)+ l(7,5,7)+ l(9,4,8)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==52) return l(3,5,7)+ l(5,4,7)+ l(7,3,7)+ l(9,2,4)+ l(9,5,7)+ l(11,1,9)+ l(13,5,7)+ l(15,5,7);
//else if(c==53) return l(3,1,9)+ l(5,1,3)+ l(7,1,8)+ l(9,1,4)+ l(9,7,9)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==54) return l(3,3,8)+ l(5,2,4)+ l(7,1,3)+ l(9,1,8)+ l(11,1,4)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==55) return l(3,1,9)+ l(5,7,9)+ l(7,6,8)+ l(9,5,7)+ l(11,4,6)+ l(13,3,5)+ l(15,3,5);
//else if(c==56) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,2,8)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==57) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,6,9)+ l(9,2,9)+ l(11,7,9)+ l(13,6,8)+ l(15,2,7);
//else if(c==58) return l(5,3,6)+ l(7,3,6)+ l(13,3,6)+ l(15,3,6);
//else if(c==59) return l(5,3,6)+ l(7,3,6)+ l(13,3,6)+ l(15,3,5)+ l(17,2,4);
//else if(c==60) return l(3,7,9)+ l(5,5,7)+ l(7,3,5)+ l(9,1,3)+ l(11,3,5)+ l(13,5,7)+ l(15,7,9);
//else if(c==61) return l(7,1,9)+ l(11,1,9);
//else if(c==62) return l(3,1,3)+ l(5,3,5)+ l(7,5,7)+ l(9,7,9)+ l(11,5,7)+ l(13,3,5)+ l(15,1,3);
//else if(c==63) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,5,8)+ l(9,4,6)+ l(11,4,6)+ l(15,4,6);
//else if(c==64) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,4,9)+ l(9,1,5)+ l(9,6,9)+ l(11,1,3)+ l(11,4,9)+ l(13,1,3)+ l(15,2,8);
else if(c==65) return l(3,4,6)+ l(5,3,7)+ l(7,2,4)+ l(7,6,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
else if(c==66) return l(3,1,8)+ l(5,2,4)+ l(5,7,9)+ l(7,2,4)+ l(7,7,9)+ l(9,2,8)+ l(11,2,4)+ l(11,7,9)+ l(13,2,4)+ l(13,7,9)+ l(15,1,8);
else if(c==67) return l(3,3,8)+ l(5,2,4)+ l(5,7,9)+ l(7,1,3)+ l(9,1,3)+ l(11,1,3)+ l(13,2,4)+ l(13,7,9)+ l(15,3,8);
//else if(c==68) return l(3,1,7)+ l(5,2,4)+ l(5,6,8)+ l(7,2,4)+ l(7,7,9)+ l(9,2,4)+ l(9,7,9)+ l(11,2,4)+ l(11,7,9)+ l(13,2,4)+ l(13,6,8)+ l(15,1,7);
//else if(c==69) return l(3,1,9)+ l(5,1,3)+ l(7,1,3)+ l(9,1,7)+ l(11,1,3)+ l(13,1,3)+ l(15,1,9);
//else if(c==70) return l(3,1,9)+ l(5,1,3)+ l(7,1,3)+ l(9,1,7)+ l(11,1,3)+ l(13,1,3)+ l(15,1,3);
//else if(c==71) return l(3,3,8)+ l(5,2,4)+ l(5,7,9)+ l(7,1,3)+ l(9,1,3)+ l(11,1,3)+ l(11,5,9)+ l(13,2,4)+ l(13,7,9)+ l(15,3,8);
//else if(c==72) return l(3,1,3)+ l(3,7,9)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==73) return l(3,2,8)+ l(5,4,6)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==74) return l(3,5,9)+ l(5,6,8)+ l(7,6,8)+ l(9,6,8)+ l(11,6,8)+ l(13,1,3)+ l(13,6,8)+ l(15,2,7);
//else if(c==75) return l(3,1,3)+ l(3,7,9)+ l(5,1,3)+ l(5,5,8)+ l(7,1,6)+ l(9,1,4)+ l(11,1,6)+ l(13,1,3)+ l(13,5,8)+ l(15,1,3)+ l(15,7,9);
//else if(c==76) return l(3,1,3)+ l(5,1,3)+ l(7,1,3)+ l(9,1,3)+ l(11,1,3)+ l(13,1,3)+ l(15,1,9);
//else if(c==77) return l(3,1,3)+ l(3,7,9)+ l(5,1,4)+ l(5,6,9)+ l(7,1,9)+ l(9,1,3)+ l(9,4,6)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==78) return l(3,1,3)+ l(3,7,9)+ l(5,1,4)+ l(5,7,9)+ l(7,1,5)+ l(7,7,9)+ l(9,1,3)+ l(9,4,6)+ l(9,7,9)+ l(11,1,3)+ l(11,5,9)+ l(13,1,3)+ l(13,6,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==79) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==80) return l(3,1,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,8)+ l(11,1,3)+ l(13,1,3)+ l(15,1,3);
//else if(c==81) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,5,9)+ l(13,1,3)+ l(13,6,8)+ l(15,2,9);
//else if(c==82) return l(3,1,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,8)+ l(11,1,3)+ l(11,5,7)+ l(13,1,3)+ l(13,6,8)+ l(15,1,3)+ l(15,7,9);
//else if(c==83) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(9,2,8)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==84) return l(3,1,9)+ l(5,4,6)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6);
//else if(c==85) return l(3,1,3)+ l(3,7,9)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==86) return l(3,1,3)+ l(3,7,9)+ l(5,1,3)+ l(5,7,9)+ l(7,2,4)+ l(7,6,8)+ l(9,2,4)+ l(9,6,8)+ l(11,3,7)+ l(13,3,7)+ l(15,4,6);
//else if(c==87) return l(3,1,3)+ l(3,7,9)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,4,6)+ l(9,7,9)+ l(11,1,3)+ l(11,4,6)+ l(11,7,9)+ l(13,1,9)+ l(15,2,4)+ l(15,6,8);
//else if(c==88) return l(3,1,3)+ l(3,7,9)+ l(5,2,4)+ l(5,6,8)+ l(7,3,7)+ l(9,4,6)+ l(11,3,7)+ l(13,2,4)+ l(13,6,8)+ l(15,1,3)+ l(15,7,9);
//else if(c==89) return l(3,1,3)+ l(3,7,9)+ l(5,2,4)+ l(5,6,8)+ l(7,3,7)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6);
//else if(c==90) return l(3,1,9)+ l(5,6,8)+ l(7,5,7)+ l(9,4,6)+ l(11,3,5)+ l(13,2,4)+ l(15,1,9);
//else if(c==91) return l(3,3,8)+ l(5,3,5)+ l(7,3,5)+ l(9,3,5)+ l(11,3,5)+ l(13,3,5)+ l(15,3,8);
//else if(c==92) return l(3,1,3)+ l(5,2,4)+ l(7,3,5)+ l(9,4,6)+ l(11,5,7)+ l(13,6,8)+ l(15,7,9);
//else if(c==93) return l(3,2,7)+ l(5,5,7)+ l(7,5,7)+ l(9,5,7)+ l(11,5,7)+ l(13,5,7)+ l(15,2,7);
//else if(c==94) return l(3,4,6)+ l(5,3,7)+ l(7,2,4)+ l(7,6,8)+ l(9,1,3)+ l(9,7,9);
//else if(c==95) return l(15,1,9);
//else if(c==96) return l(3,3,6)+ l(5,4,6)+ l(7,5,7);
else if(c==97) return l(7,2,8)+ l(9,7,9)+ l(11,2,9)+ l(13,1,3)+ l(13,6,9)+ l(15,2,9);
else if(c==98) return l(3,1,3)+ l(5,1,3)+ l(7,1,8)+ l(9,1,4)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,4)+ l(13,7,9)+ l(15,1,8);
else if(c==99) return l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(13,1,3)+ l(15,2,9);
//else if(c==100) return l(3,7,9)+ l(5,7,9)+ l(7,2,9)+ l(9,1,3)+ l(9,6,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,6,9)+ l(15,2,9);
//else if(c==101) return l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,9)+ l(13,1,3)+ l(15,2,8);
//else if(c==102) return l(3,4,8)+ l(5,3,5)+ l(5,7,9)+ l(7,3,5)+ l(9,1,7)+ l(11,3,5)+ l(13,3,5)+ l(15,3,5);
//else if(c==103) return l(7,2,9)+ l(9,1,3)+ l(9,6,8)+ l(11,2,7)+ l(13,1,3)+ l(15,2,8)+ l(17,1,3)+ l(17,7,9)+ l(19,2,8);
//else if(c==104) return l(3,1,3)+ l(5,1,3)+ l(7,1,8)+ l(9,1,4)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==105) return l(3,4,6)+ l(7,3,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==106) return l(3,6,8)+ l(7,6,8)+ l(9,6,8)+ l(11,6,8)+ l(13,6,8)+ l(15,1,3)+ l(15,6,8)+ l(17,1,3)+ l(17,6,8)+ l(19,2,7);
//else if(c==107) return l(3,1,3)+ l(5,1,3)+ l(7,1,3)+ l(7,5,7)+ l(9,1,3)+ l(9,4,6)+ l(11,1,5)+ l(13,1,3)+ l(13,5,7)+ l(15,1,3)+ l(15,7,9);
//else if(c==108) return l(3,3,6)+ l(5,4,6)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,3,7);
//else if(c==109) return l(7,1,4)+ l(7,6,8)+ l(9,1,9)+ l(11,1,3)+ l(11,4,6)+ l(11,7,9)+ l(13,1,3)+ l(13,4,6)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==110) return l(7,1,8)+ l(9,1,4)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==111) return l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==112) return l(7,1,8)+ l(9,1,4)+ l(9,7,9)+ l(11,1,4)+ l(11,7,9)+ l(13,1,8)+ l(15,1,3)+ l(17,1,3)+ l(19,1,3);
//else if(c==113) return l(7,2,9)+ l(9,1,3)+ l(9,6,9)+ l(11,1,3)+ l(11,6,9)+ l(13,2,9)+ l(15,7,9)+ l(17,7,9)+ l(19,7,9);
//else if(c==114) return l(7,1,3)+ l(7,4,8)+ l(9,2,5)+ l(9,7,9)+ l(11,2,4)+ l(13,2,4)+ l(15,2,4);
//else if(c==115) return l(7,2,8)+ l(9,1,3)+ l(11,2,8)+ l(13,7,9)+ l(15,1,8);
//else if(c==116) return l(3,3,5)+ l(5,3,5)+ l(7,1,7)+ l(9,3,5)+ l(11,3,5)+ l(13,3,5)+ l(13,6,8)+ l(15,4,7);
//else if(c==117) return l(7,1,3)+ l(7,6,8)+ l(9,1,3)+ l(9,6,8)+ l(11,1,3)+ l(11,6,8)+ l(13,1,3)+ l(13,6,8)+ l(15,2,9);
//else if(c==118) return l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,2,4)+ l(11,6,8)+ l(13,3,7)+ l(15,4,6);
//else if(c==119) return l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,4,6)+ l(11,7,9)+ l(13,1,9)+ l(15,2,4)+ l(15,6,8);
//else if(c==120) return l(7,1,3)+ l(7,6,8)+ l(9,2,4)+ l(9,5,7)+ l(11,3,6)+ l(13,2,4)+ l(13,5,7)+ l(15,1,3)+ l(15,6,8);
//else if(c==121) return l(7,1,3)+ l(7,6,8)+ l(9,1,3)+ l(9,6,8)+ l(11,1,3)+ l(11,5,8)+ l(13,2,8)+ l(15,6,8)+ l(17,1,3)+ l(17,6,8)+ l(19,2,7);
//else if(c==122) return l(7,1,9)+ l(9,6,8)+ l(11,4,7)+ l(13,3,5)+ l(15,1,9);
//else if(c==123) return l(3,5,9)+ l(5,4,6)+ l(7,5,7)+ l(9,3,6)+ l(11,5,7)+ l(13,4,6)+ l(15,5,9);
//else if(c==124) return l(3,4,6)+ l(5,4,6)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6);
//else if(c==125) return l(3,1,5)+ l(5,4,6)+ l(7,3,5)+ l(9,4,7)+ l(11,3,5)+ l(13,4,6)+ l(15,1,5);
//else if(c==126) return l(3,2,5)+ l(3,7,9)+ l(5,1,3)+ l(5,4,6)+ l(5,7,9)+ l(7,1,3)+ l(7,5,8);
//else if(c==127) return l(3,1,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,3)+ l(7,4,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,7)+ l(13,3,5)+ l(15,3,5)+ l(17,3,5)+ l(19,3,5);
//else if(c==128) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,6)+ l(15,7,9)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==129) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,5)+ l(11,6,8)+ l(13,5,8)+ l(15,6,8)+ l(17,6,8)+ l(19,5,9);
//else if(c==130) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,8)+ l(13,4,6)+ l(13,7,9)+ l(15,6,8)+ l(17,5,7)+ l(19,4,9);
//else if(c==131) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,9)+ l(13,7,9)+ l(15,5,8)+ l(17,7,9)+ l(19,4,8);
//else if(c==132) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,5)+ l(11,6,8)+ l(13,5,8)+ l(15,4,8)+ l(17,3,9)+ l(19,6,8);
//else if(c==133) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,9)+ l(13,4,6)+ l(15,4,8)+ l(17,7,9)+ l(19,4,8);
//else if(c==134) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,5)+ l(11,6,9)+ l(13,5,7)+ l(15,4,8)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==135) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,9)+ l(13,7,9)+ l(15,6,8)+ l(17,5,7)+ l(19,5,7);
//else if(c==136) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,8)+ l(13,4,6)+ l(13,7,9)+ l(15,5,8)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==137) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,8)+ l(13,4,6)+ l(13,7,9)+ l(15,5,9)+ l(17,6,8)+ l(19,4,7);
//else if(c==138) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,9)+ l(17,4,6)+ l(17,7,9)+ l(19,4,6)+ l(19,7,9);
//else if(c==139) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,8)+ l(17,4,6)+ l(17,7,9)+ l(19,4,8);
//else if(c==140) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,9)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,5,9);
//else if(c==141) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,6)+ l(15,7,9)+ l(17,4,6)+ l(17,7,9)+ l(19,4,8);
//else if(c==142) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,9);
//else if(c==143) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,5)+ l(9,1,3)+ l(9,4,6)+ l(11,2,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,6);
//else if(c==144) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,4)+ l(11,5,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,6)+ l(15,7,9)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==145) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,4)+ l(11,6,8)+ l(13,5,8)+ l(15,6,8)+ l(17,6,8)+ l(19,5,9);
//else if(c==146) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,4)+ l(11,5,8)+ l(13,4,6)+ l(13,7,9)+ l(15,6,8)+ l(17,5,7)+ l(19,4,9);
//else if(c==147) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,9)+ l(13,7,9)+ l(15,5,8)+ l(17,7,9)+ l(19,4,8);
//else if(c==148) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,4)+ l(11,6,8)+ l(13,5,8)+ l(15,4,8)+ l(17,3,9)+ l(19,6,8);
//else if(c==149) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,9)+ l(13,4,6)+ l(15,4,8)+ l(17,7,9)+ l(19,4,8);
//else if(c==150) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,4)+ l(11,6,9)+ l(13,5,7)+ l(15,4,8)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==151) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,9)+ l(13,7,9)+ l(15,6,8)+ l(17,5,7)+ l(19,5,7);
//else if(c==152) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,4)+ l(11,5,8)+ l(13,4,6)+ l(13,7,9)+ l(15,5,8)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==153) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,4)+ l(11,5,8)+ l(13,4,6)+ l(13,7,9)+ l(15,5,9)+ l(17,6,8)+ l(19,4,7);
//else if(c==154) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,4)+ l(11,5,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,9)+ l(17,4,6)+ l(17,7,9)+ l(19,4,6)+ l(19,7,9);
//else if(c==155) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,8)+ l(17,4,6)+ l(17,7,9)+ l(19,4,8);
//else if(c==156) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,4)+ l(11,5,9)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,5,9);
//else if(c==157) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,6)+ l(15,7,9)+ l(17,4,6)+ l(17,7,9)+ l(19,4,8);
//else if(c==158) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,9);
//else if(c==159) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,2,6)+ l(9,3,5)+ l(11,1,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,6);
//else if(c==160) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,3)+ l(11,4,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,6)+ l(15,7,9)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==161) return l(3,4,6)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6);
//else if(c==162) return l(5,4,6)+ l(7,2,8)+ l(9,1,3)+ l(9,4,6)+ l(9,7,9)+ l(11,1,3)+ l(11,4,6)+ l(13,1,3)+ l(13,4,6)+ l(13,7,9)+ l(15,2,8)+ l(17,4,6);
//else if(c==163) return l(3,4,8)+ l(5,3,5)+ l(5,7,9)+ l(7,3,5)+ l(9,1,7)+ l(11,3,5)+ l(13,2,7)+ l(15,1,5)+ l(15,6,9)+ l(17,2,4);
//else if(c==164) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,3)+ l(11,4,8)+ l(13,5,8)+ l(15,4,8)+ l(17,3,9)+ l(19,6,8);
//else if(c==165) return l(3,1,3)+ l(3,7,9)+ l(5,2,4)+ l(5,6,8)+ l(7,3,7)+ l(9,4,6)+ l(11,1,9)+ l(13,4,6)+ l(15,4,6);
//else if(c==166) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,3)+ l(11,4,9)+ l(13,5,7)+ l(15,4,8)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==167) return l(3,3,8)+ l(5,2,4)+ l(7,3,7)+ l(9,2,4)+ l(9,6,8)+ l(11,3,7)+ l(13,6,8)+ l(15,2,7);
//else if(c==168) return l(5,1,3)+ l(5,7,9)+ l(7,2,8)+ l(9,2,4)+ l(9,6,8)+ l(11,2,8)+ l(13,1,3)+ l(13,7,9);
//else if(c==169) return l(3,3,7)+ l(5,2,4)+ l(5,6,8)+ l(7,1,3)+ l(7,4,9)+ l(9,1,5)+ l(9,7,9)+ l(11,1,5)+ l(11,7,9)+ l(13,1,3)+ l(13,4,9)+ l(15,2,4)+ l(15,6,8)+ l(17,3,7);
//else if(c==170) return l(3,2,8)+ l(5,7,9)+ l(7,2,9)+ l(9,1,3)+ l(9,6,9)+ l(11,2,9)+ l(15,1,9);
//else if(c==171) return l(3,4,6)+ l(3,7,9)+ l(5,3,5)+ l(5,6,8)+ l(7,2,4)+ l(7,5,7)+ l(9,1,3)+ l(9,4,6)+ l(11,2,4)+ l(11,5,7)+ l(13,3,5)+ l(13,6,8)+ l(15,4,6)+ l(15,7,9);
//else if(c==172) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,3)+ l(11,4,9)+ l(13,4,6)+ l(15,4,6)+ l(17,4,6)+ l(19,5,9);
//else if(c==173) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,3)+ l(11,4,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,6)+ l(15,7,9)+ l(17,4,6)+ l(17,7,9)+ l(19,4,8);
//else if(c==174) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,3)+ l(11,4,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,9);
//else if(c==175) return l(3,2,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,3)+ l(11,4,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,6);
//else if(c==176) return l(3,3,7)+ l(5,2,4)+ l(5,6,8)+ l(7,3,7);
//else if(c==177) return l(5,4,6)+ l(7,4,6)+ l(9,1,9)+ l(11,4,6)+ l(13,4,6)+ l(15,1,9);
//else if(c==178) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(5,4,7)+ l(7,3,5)+ l(9,2,8);
//else if(c==179) return l(1,2,8)+ l(3,6,8)+ l(5,4,7)+ l(7,6,8)+ l(9,2,7);
//else if(c==180) return l(3,1,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,5)+ l(9,1,3)+ l(9,4,6)+ l(11,1,5)+ l(11,6,8)+ l(13,5,8)+ l(15,4,8)+ l(17,3,9)+ l(19,6,8);
//else if(c==181) return l(7,2,4)+ l(7,7,9)+ l(9,2,4)+ l(9,7,9)+ l(11,2,4)+ l(11,7,9)+ l(13,2,5)+ l(13,6,9)+ l(15,2,9)+ l(17,2,4)+ l(19,1,3);
//else if(c==182) return l(3,2,9)+ l(5,1,4)+ l(5,5,9)+ l(7,1,4)+ l(7,5,9)+ l(9,2,9)+ l(11,5,9)+ l(13,5,9)+ l(15,5,9);
//else if(c==183) return l(7,3,6)+ l(9,3,6);
//else if(c==184) return l(3,1,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,5)+ l(9,1,3)+ l(9,4,6)+ l(11,1,8)+ l(13,4,6)+ l(13,7,9)+ l(15,5,8)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==185) return l(1,4,6)+ l(3,3,6)+ l(5,4,6)+ l(7,4,6)+ l(9,3,7);
//else if(c==186) return l(3,2,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,2,8)+ l(15,1,9);
//else if(c==187) return l(3,1,3)+ l(3,4,6)+ l(5,2,4)+ l(5,5,7)+ l(7,3,5)+ l(7,6,8)+ l(9,4,6)+ l(9,7,9)+ l(11,3,5)+ l(11,6,8)+ l(13,2,4)+ l(13,5,7)+ l(15,1,3)+ l(15,4,6);
//else if(c==188) return l(3,2,4)+ l(5,1,4)+ l(5,6,8)+ l(7,2,4)+ l(7,5,7)+ l(9,2,6)+ l(11,3,5)+ l(11,6,8)+ l(13,2,4)+ l(13,5,8)+ l(15,1,3)+ l(15,4,8)+ l(17,3,9)+ l(19,6,8);
//else if(c==189) return l(3,2,4)+ l(5,1,4)+ l(5,6,8)+ l(7,2,4)+ l(7,5,7)+ l(9,2,6)+ l(11,3,8)+ l(13,2,6)+ l(13,7,9)+ l(15,1,3)+ l(15,6,8)+ l(17,5,7)+ l(19,4,9);
//else if(c==190) return l(3,1,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,5)+ l(9,1,3)+ l(9,4,6)+ l(11,1,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,9);
//else if(c==191) return l(3,4,6)+ l(7,4,6)+ l(9,4,6)+ l(11,2,5)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==192) return l(1,3,6)+ l(3,5,8)+ l(5,4,6)+ l(7,3,7)+ l(9,2,4)+ l(9,6,8)+ l(11,1,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==193) return l(1,4,7)+ l(3,2,5)+ l(5,4,6)+ l(7,3,7)+ l(9,2,4)+ l(9,6,8)+ l(11,1,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==194) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(5,4,6)+ l(7,3,7)+ l(9,2,4)+ l(9,6,8)+ l(11,1,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==195) return l(1,3,6)+ l(1,7,9)+ l(3,2,4)+ l(3,5,8)+ l(5,4,6)+ l(7,3,7)+ l(9,2,4)+ l(9,6,8)+ l(11,1,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==196) return l(1,2,4)+ l(1,6,8)+ l(5,4,6)+ l(7,3,7)+ l(9,2,4)+ l(9,6,8)+ l(11,1,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==197) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(5,3,7)+ l(7,3,7)+ l(9,2,4)+ l(9,6,8)+ l(11,1,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==198) return l(3,3,9)+ l(5,2,6)+ l(7,1,3)+ l(7,4,6)+ l(9,1,3)+ l(9,4,8)+ l(11,1,6)+ l(13,1,3)+ l(13,4,6)+ l(15,1,3)+ l(15,4,9);
//else if(c==199) return l(3,3,8)+ l(5,2,4)+ l(5,7,9)+ l(7,1,3)+ l(9,1,3)+ l(11,1,3)+ l(13,2,4)+ l(13,7,9)+ l(15,3,8)+ l(17,5,7)+ l(19,3,7);
//else if(c==200) return l(1,2,5)+ l(3,4,7)+ l(5,1,9)+ l(7,1,3)+ l(9,1,7)+ l(11,1,3)+ l(13,1,3)+ l(15,1,9);
//else if(c==201) return l(1,5,8)+ l(3,3,6)+ l(5,1,9)+ l(7,1,3)+ l(9,1,7)+ l(11,1,3)+ l(13,1,3)+ l(15,1,9);
//else if(c==202) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(5,1,9)+ l(7,1,3)+ l(9,1,6)+ l(11,1,3)+ l(13,1,3)+ l(15,1,9);
//else if(c==203) return l(1,2,4)+ l(1,6,8)+ l(5,1,9)+ l(7,1,3)+ l(9,1,7)+ l(11,1,3)+ l(13,1,3)+ l(15,1,9);
//else if(c==204) return l(1,3,6)+ l(3,5,8)+ l(5,2,8)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==205) return l(1,4,7)+ l(3,2,5)+ l(5,2,8)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==206) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(5,2,8)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==207) return l(1,2,4)+ l(1,6,8)+ l(5,2,8)+ l(7,4,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==208) return l(3,1,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,3)+ l(7,4,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,6)+ l(15,7,9)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==209) return l(1,3,6)+ l(1,7,9)+ l(3,2,4)+ l(3,5,8)+ l(5,1,4)+ l(5,7,9)+ l(7,1,5)+ l(7,7,9)+ l(9,1,3)+ l(9,4,6)+ l(9,7,9)+ l(11,1,3)+ l(11,5,9)+ l(13,1,3)+ l(13,6,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==210) return l(1,3,6)+ l(3,5,8)+ l(5,2,8)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==211) return l(1,4,7)+ l(3,2,5)+ l(5,2,8)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==212) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(5,2,8)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==213) return l(1,2,5)+ l(1,6,8)+ l(3,1,3)+ l(3,4,7)+ l(5,2,8)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==214) return l(1,2,4)+ l(1,6,8)+ l(5,2,8)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==215) return l(3,2,9)+ l(5,1,3)+ l(5,4,6)+ l(7,1,3)+ l(7,4,6)+ l(9,1,3)+ l(9,4,8)+ l(11,1,3)+ l(11,4,6)+ l(13,1,3)+ l(13,4,6)+ l(15,2,9);
//else if(c==216) return l(1,7,9)+ l(3,2,8)+ l(5,1,3)+ l(5,6,9)+ l(7,1,3)+ l(7,5,9)+ l(9,1,3)+ l(9,4,6)+ l(9,7,9)+ l(11,1,5)+ l(11,7,9)+ l(13,1,4)+ l(13,7,9)+ l(15,2,8)+ l(17,1,3);
//else if(c==217) return l(1,2,5)+ l(3,4,7)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==218) return l(1,5,8)+ l(3,3,6)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==219) return l(1,4,6)+ l(3,3,7)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==220) return l(1,2,4)+ l(1,6,8)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==221) return l(1,2,4)+ l(1,6,8)+ l(5,1,3)+ l(5,7,9)+ l(7,2,4)+ l(7,6,8)+ l(9,3,7)+ l(11,4,6)+ l(13,4,6)+ l(15,4,6);
//else if(c==222) return l(3,1,5)+ l(5,1,3)+ l(5,4,6)+ l(7,1,3)+ l(7,4,6)+ l(9,1,3)+ l(9,4,6)+ l(11,1,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,9);
//else if(c==223) return l(3,3,7)+ l(5,2,4)+ l(5,6,8)+ l(7,1,3)+ l(7,6,8)+ l(9,1,7)+ l(11,1,3)+ l(11,6,8)+ l(13,1,5)+ l(13,7,9)+ l(15,1,3)+ l(15,4,8)+ l(17,1,3);
//else if(c==224) return l(3,3,6)+ l(5,5,8)+ l(7,2,8)+ l(9,7,9)+ l(11,2,9)+ l(13,1,3)+ l(13,6,9)+ l(15,2,9);
//else if(c==225) return l(3,4,7)+ l(5,2,5)+ l(7,2,8)+ l(9,7,9)+ l(11,2,9)+ l(13,1,3)+ l(13,6,9)+ l(15,2,9);
//else if(c==226) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(7,2,8)+ l(9,7,9)+ l(11,2,9)+ l(13,1,3)+ l(13,6,9)+ l(15,2,9);
//else if(c==227) return l(1,3,6)+ l(1,7,9)+ l(3,2,4)+ l(3,5,8)+ l(7,2,8)+ l(9,7,9)+ l(11,2,9)+ l(13,1,3)+ l(13,6,9)+ l(15,2,9);
//else if(c==228) return l(3,2,4)+ l(3,6,8)+ l(7,2,8)+ l(9,7,9)+ l(11,2,9)+ l(13,1,3)+ l(13,6,9)+ l(15,2,9);
//else if(c==229) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(5,3,7)+ l(7,2,8)+ l(9,7,9)+ l(11,2,9)+ l(13,1,3)+ l(13,6,9)+ l(15,2,9);
//else if(c==230) return l(7,2,8)+ l(9,4,6)+ l(9,7,9)+ l(11,2,9)+ l(13,1,3)+ l(13,4,6)+ l(15,2,9);
//else if(c==231) return l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8)+ l(17,5,7)+ l(19,3,7);
//else if(c==232) return l(3,3,6)+ l(5,5,8)+ l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,9)+ l(13,1,3)+ l(15,2,8);
//else if(c==233) return l(3,4,7)+ l(5,2,5)+ l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,9)+ l(13,1,3)+ l(15,2,8);
//else if(c==234) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,9)+ l(13,1,3)+ l(15,2,8);
//else if(c==235) return l(3,2,4)+ l(3,6,8)+ l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,9)+ l(13,1,3)+ l(15,2,8);
//else if(c==236) return l(3,2,5)+ l(5,4,7)+ l(7,3,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==237) return l(3,4,7)+ l(5,2,5)+ l(7,3,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==238) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(7,3,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==239) return l(3,2,4)+ l(3,6,8)+ l(7,3,6)+ l(9,4,6)+ l(11,4,6)+ l(13,4,6)+ l(15,2,8);
//else if(c==240) return l(3,1,6)+ l(5,1,3)+ l(7,1,5)+ l(9,1,3)+ l(11,1,3)+ l(11,5,8)+ l(13,4,6)+ l(13,7,9)+ l(15,4,6)+ l(15,7,9)+ l(17,4,6)+ l(17,7,9)+ l(19,5,8);
//else if(c==241) return l(1,2,5)+ l(1,6,8)+ l(3,1,3)+ l(3,4,7)+ l(7,1,8)+ l(9,1,4)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,3)+ l(15,7,9);
//else if(c==242) return l(3,3,6)+ l(5,5,8)+ l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==243) return l(3,4,7)+ l(5,2,5)+ l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
else if(c==244) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
else if(c==245) return l(1,2,5)+ l(1,6,8)+ l(3,1,3)+ l(3,4,7)+ l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
else if(c==246) return l(3,2,4)+ l(3,6,8)+ l(7,2,8)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,2,8);
//else if(c==247) return l(7,2,8)+ l(9,1,3)+ l(9,4,6)+ l(9,7,9)+ l(11,1,3)+ l(11,4,9)+ l(13,1,3)+ l(13,4,6)+ l(15,2,9);
//else if(c==248) return l(5,7,9)+ l(7,2,8)+ l(9,1,3)+ l(9,5,9)+ l(11,1,3)+ l(11,4,6)+ l(11,7,9)+ l(13,1,5)+ l(13,7,9)+ l(15,2,8)+ l(17,1,3);
//else if(c==249) return l(3,2,5)+ l(5,4,7)+ l(7,1,3)+ l(7,6,8)+ l(9,1,3)+ l(9,6,8)+ l(11,1,3)+ l(11,6,8)+ l(13,1,3)+ l(13,6,8)+ l(15,2,9);
//else if(c==250) return l(3,4,7)+ l(5,2,5)+ l(7,1,3)+ l(7,6,8)+ l(9,1,3)+ l(9,6,8)+ l(11,1,3)+ l(11,6,8)+ l(13,1,3)+ l(13,6,8)+ l(15,2,9);
//else if(c==251) return l(1,3,7)+ l(3,2,4)+ l(3,6,8)+ l(7,1,3)+ l(7,6,8)+ l(9,1,3)+ l(9,6,8)+ l(11,1,3)+ l(11,6,8)+ l(13,1,3)+ l(13,6,8)+ l(15,2,9);
//else if(c==252) return l(3,2,4)+ l(3,6,8)+ l(7,1,3)+ l(7,6,8)+ l(9,1,3)+ l(9,6,8)+ l(11,1,3)+ l(11,6,8)+ l(13,1,3)+ l(13,6,8)+ l(15,2,9);
//else if(c==253) return l(3,2,4)+ l(3,6,8)+ l(7,1,3)+ l(7,6,8)+ l(9,1,3)+ l(9,6,8)+ l(11,1,3)+ l(11,5,8)+ l(13,2,8)+ l(15,6,8)+ l(17,1,3)+ l(17,6,8)+ l(19,2,7);
//else if(c==254) return l(3,1,6)+ l(5,1,3)+ l(7,1,5)+ l(9,1,3)+ l(11,1,3)+ l(11,4,9)+ l(13,4,6)+ l(15,4,8)+ l(17,4,6)+ l(19,4,9);
//else if(c==255) return l(3,1,9)+ l(5,1,3)+ l(5,7,9)+ l(7,1,3)+ l(7,7,9)+ l(9,1,3)+ l(9,7,9)+ l(11,1,3)+ l(11,7,9)+ l(13,1,3)+ l(13,7,9)+ l(15,1,9);
else return 0.0;      
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec4 c = vec4(0.0, 0.0, 0.0, 0.0);
    
    vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 aspect = vec2(1.,iResolution.y/iResolution.x);
  
    vec2 uvT = vec2(uv.x, 1.0-uv.y)* 110.; 
    uvT = 0.5 + (uvT -0.5)*aspect;
        
	vec2 s = FONT_SIZE;

    c += vt220Font(uvT - vec2(0., 0.)*s, 65);
    c += vt220Font(uvT - vec2(1., 0.)*s, 97);

    c += vt220Font(uvT - vec2(4., 0.)*s, 66);
    c += vt220Font(uvT - vec2(5., 0.)*s, 98);

    c += vt220Font(uvT - vec2(9., 0.)*s, 67);
    c += vt220Font(uvT - vec2(10., 0.)*s, 99);
   
    c += vt220Font(uvT - vec2(0., 1.)*s, 49);
    c += vt220Font(uvT - vec2(1., 1.)*s, 50);
    c += vt220Font(uvT - vec2(2., 1.)*s, 51);
    
    c += vt220Font(uvT - vec2(4., 1.)*s, 35);
    c += vt220Font(uvT - vec2(5., 1.)*s, 36);
    c += vt220Font(uvT - vec2(6., 1.)*s, 37);
    
    c += vt220Font(uvT - vec2(8., 1.)*s, 244);
    c += vt220Font(uvT - vec2(9., 1.)*s, 245);
    c += vt220Font(uvT - vec2(10., 1.)*s, 246);
    
    c += vt220Font(uvT - vec2(0., 2.)*s, 35);
    if(floor(mod(iGlobalTime, 2.0)) > 0.5)
    	c += vt220Font(uvT - vec2(1., 2.)*s, 20);
    
	fragColor = c - vec4(0.3, 0.0, 0.3, 0.0);
}

 void main(void)
{
  //just some shit to wrap shadertoy's stuff
  vec2 FragCoord = vTexCoord.xy*OutputSize.xy;
  mainImage(FragColor,FragCoord);
}
#endif
