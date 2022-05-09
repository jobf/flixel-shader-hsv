import flixel.system.FlxAssets.FlxShader;

/**
	see https://gamedev.stackexchange.com/questions/59797/glsl-shader-change-hue-saturation-brightness
**/
class HSVShader extends FlxShader
{
	@:glFragmentSource('
	#pragma header
	uniform vec3 HSV;
	
	vec3 rgb2hsv(vec3 c)
	{
		vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
		vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
		vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

		float d = q.x - min(q.w, q.y);
		float e = 1.0e-10;
		return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
	}

	vec3 hsv2rgb(vec3 c)
	{
		vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
		vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
		return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
		
		// if accumulating the output, cyan, magenta, yellow, especially pastels
		// and of course whites are overexposed much sooner
		// than mostly-saturated red, green, or blue
		// a work around is by normalizing the last mix before applying the gain, like so:
		// return c.z * normalize(mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y));
	}

	void main(){
		vec4 textureColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		vec3 fragRGB = textureColor.rgb;
		vec3 fragHSV = rgb2hsv(fragRGB).xyz;
		fragHSV.xzy += mod(HSV.xzy, 1.0);
		fragRGB = hsv2rgb(fragHSV);
		gl_FragColor = vec4(fragRGB, textureColor.w);
	}
	')
	public function new()
	{
		super();
		HSV.value = [1.0, 1.0, 1.0];
	}

	/** set hue, range 0 to 360 **/
	public function setH(h:Int)
	{
		HSV.value[0] = h / 360;
	}

	/** set saturation, range 0 to 360 **/
	public function setS(s:Int)
	{
		HSV.value[1] = s / 360;
	}

	/** set value (brightness), range 0 to 360 **/
	public function setV(v:Int)
	{
		HSV.value[2] = v / 360;
	}
}
