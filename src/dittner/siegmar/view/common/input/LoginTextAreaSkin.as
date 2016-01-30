package dittner.siegmar.view.common.input {
import flash.display.Graphics;

import spark.skins.mobile.TextAreaSkin;

public class LoginTextAreaSkin extends TextAreaSkin {

	public function LoginTextAreaSkin() {
		super();
	}

	override protected function drawBackground(w:Number, h:Number):void {
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, 0);
		g.drawRect(0, 0, w, h);
	}

}
}
