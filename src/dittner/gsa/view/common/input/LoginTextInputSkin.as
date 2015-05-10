package dittner.gsa.view.common.input {
import flash.display.Graphics;

import spark.skins.mobile.TextInputSkin;

public class LoginTextInputSkin extends TextInputSkin {

	public function LoginTextInputSkin() {
		super();
	}

	override protected function drawBackground(w:Number, h:Number):void {
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, 0x595ab6);
		g.drawRect(0, 0, w, h);
	}

}
}
