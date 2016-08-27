package de.dittner.siegmar.view.common.scroll.cap {

import mx.skins.Border;

public class MXScrollThumbSkin extends Border {

	public function MXScrollThumbSkin() {
		super();
	}

	override public function get measuredWidth():Number {
		return 16;
	}

	override public function get measuredHeight():Number {
		return 10;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		graphics.clear();

		drawRoundRect(2, 0, w - 3, h, 2, [0xc2c2c1, 0xc2c2c1], 1, horizontalGradientMatrix(2, 0, w - 3, h));
		drawRoundRect(3, 1, w - 5, h - 2, 2, [0xffFFff, 0xebeff2], 1, horizontalGradientMatrix(3, 1, w - 5, h - 2));

	}
}

}
