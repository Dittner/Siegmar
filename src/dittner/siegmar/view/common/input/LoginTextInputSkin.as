package dittner.siegmar.view.common.input {
import flash.display.Graphics;

import spark.skins.spark.TextInputSkin;

public class LoginTextInputSkin extends TextInputSkin {

	public function LoginTextInputSkin() {
		super();
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, 0x595ab6);
		g.drawRect(0, 0, w, h);
	}

}
}
