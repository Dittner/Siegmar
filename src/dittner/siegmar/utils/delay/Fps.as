package dittner.siegmar.utils.delay {
import mx.core.FlexGlobals;

public class Fps {
	public function Fps() {}
	public static function setRate(value:int):void {
		FlexGlobals.topLevelApplication.frameRate = value;
	}

	public static function get rate():int {
		if (!FlexGlobals.topLevelApplication.frameRate) FlexGlobals.topLevelApplication.frameRate = 60;
		return FlexGlobals.topLevelApplication.frameRate;
	}

}
}
