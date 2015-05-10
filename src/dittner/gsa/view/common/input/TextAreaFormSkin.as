package dittner.gsa.view.common.input {
import dittner.gsa.view.common.utils.AppColors;

import flash.display.Graphics;

import spark.skins.mobile.TextAreaSkin;

public class TextAreaFormSkin extends TextAreaSkin {

	public function TextAreaFormSkin() {super(); }

	override protected function drawBackground(w:Number, h:Number):void {}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, AppColors.INPUT_BORDER);
		g.beginFill(AppColors.INPUT_CONTENT);
		g.drawRect(0, 0, w - 1, h - 1);
		g.endFill();
	}

}
}
