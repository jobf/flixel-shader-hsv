package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var hsvRange:Int;
	var hsv:HSVShader;
	var isAlteringBrightness = true;
	var axisInfoY:FlxText;

	override public function create()
	{
		super.create();

		hsvRange = 360;
		hsv = new HSVShader(hsvRange);

		var sprite = new FlxSprite("assets/test.png");
		sprite.shader = hsv;
		add(sprite);

		initInfo();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		var x = Std.int((FlxG.mouse.x / FlxG.width) * 360);
		var y = Std.int((FlxG.mouse.y / FlxG.height) * 360);

		hsv.setH(x);

		if (isAlteringBrightness)
		{
			hsv.setV(y);
		}
		else
		{
			hsv.setS(y);
		}

		if (FlxG.mouse.justPressed)
		{
			isAlteringBrightness = !isAlteringBrightness;
			axisInfoY.text = getAxisInfoY();
		}
	}

	function getAxisInfoY():String
	{
		return isAlteringBrightness ? "Y : BRIGHTNESS" : "Y : SATURATION";
	}

	function initInfo()
	{
		axisInfoY = new FlxText(0, 0, 0, getAxisInfoY(), 42);
		axisInfoY.color = FlxColor.BLACK;
		axisInfoY.screenCenter();
		axisInfoY.y += axisInfoY.height;
		add(axisInfoY);

		var toggleInfo = new FlxText(0, 0, 0, "CLICK MOUSE TO TOGGLE", 24);
		toggleInfo.color = FlxColor.BLACK;
		toggleInfo.screenCenter();
		toggleInfo.y = axisInfoY.y + axisInfoY.height;
		add(toggleInfo);

		var axisInfoX = new FlxText(0, 0, 0, "X : HUE", 42);
		axisInfoX.color = FlxColor.BLACK;
		axisInfoX.screenCenter();
		axisInfoX.y -= axisInfoX.height;
		add(axisInfoX);
	}

}
