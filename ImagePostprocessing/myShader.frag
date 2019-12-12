#version 330 core

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform float limRatio;
uniform bool applyFunction;

uniform bool fullScreenImage;

uniform float imTopLeftU;
uniform float imTopLeftV;
uniform float imScale;

/* --- ADD AS MANY PARAMETERS AS YOU WANT HERE --- */
uniform float power; // min 0 max 2 default 0.587
uniform float alpha; // min 0 max 10 default 30.2
uniform float beta; // min -2 max 2 default 1.5
uniform float offset; // min -1 max 1 default 0.13
/*-------- SPECIFY YOUR FUNCTION HERE --------------*/
float f(float x){
	return x+beta*exp(-pow(abs(x-offset),power)*alpha);
}
/*-------------------------------------------------*/

float fRed(float x){
	return f(x);
}
float fGreen(float x){
	return f(x);
}
float fBlue(float x){
	return f(x);
}

float bump(float x){
	float margin = 0.005;
	return smoothstep(-margin, 0, x) - smoothstep(0, margin, x);
}

float creneau(float x, float period){
	if( mod(x, period) < period/2 )
		return 1;
	return 0;
}

void main() {
	vec2 uv = vertTexCoord.st;
	vec3 color;
	if( fullScreenImage ){
		vec3 texColor = texture2D(texture, uv).rgb;
		color = vec3(fRed(texColor.r), fGreen(texColor.g), fBlue(texColor.b));
	}
	else{
		// Curve part
		if( uv.x < limRatio ){
			// remap
			uv.x /= limRatio;
			uv.y = 1.-uv.y;
			// Frame
			float frameSize = 0.005;
			if( abs(uv.x-0.5)>0.5-frameSize || abs(uv.y-0.5)>0.5-frameSize){
				color = vec3(64, 64, 255)/255.;
			}
			else{
				// remap
				uv.x = (uv.x - frameSize) / (1. - 2.*frameSize);
				uv.y = (uv.y - frameSize) / (1. - 2.*frameSize);
				// Params
				float indicatorHeight = 0.03;
					// Curve BBox
				float xMin = indicatorHeight;
				float yMin = indicatorHeight;
				float xMax = 1.;
				float yMax = 1.;
				// 
				if( uv.x > xMin && uv.x < xMax && uv.y > yMin && uv.y < yMax ){
					// remap
					uv.x = (uv.x - xMin) / (xMax - xMin);
					uv.y = (uv.y - yMin) / (yMax - yMin);
					// Draw Curve
					float tRed = bump((uv.y)-fRed(uv.x));
					float tGreen = bump((uv.y)-fGreen(uv.x));
					float tBlue = bump((uv.y)-fBlue(uv.x));
				  	color = vec3(tRed, tGreen, tBlue);
				  	// Background
				  	color += vec3(0.15);
				  	// Identity
				  	color += vec3(bump(uv.x-uv.y)) * 0.45 * creneau(length(uv), 0.07);
				}
			  	// Background
			  	else {
			  		// symetry y=x
			  		if( uv.y > uv.x )
			  			uv = uv.yx;
			  		// Grayscale Indicator
			  		if( uv.x  > xMin && uv.x < xMax && uv.y < yMin && uv.y > yMin - indicatorHeight){
			  			color = vec3((uv.x-xMin)/(xMax-xMin));
			  		}
			  	}
			}
		}
		// Image part
		else{
			uv.x = (uv.x - limRatio) / (1.-limRatio);
			uv = uv * imScale + vec2(imTopLeftU, imTopLeftV);
			vec3 texColor = texture2D(texture, uv).rgb;
			if( applyFunction )
				color = vec3(fRed(texColor.r), fGreen(texColor.g), fBlue(texColor.b));
			else
				color = texColor;
		 	}
		 }
	gl_FragColor =  vec4(color, 1.0);
}