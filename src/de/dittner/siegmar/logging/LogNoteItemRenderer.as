package de.dittner.siegmar.logging {
import de.dittner.siegmar.utils.Values;
import de.dittner.siegmar.view.common.renderer.ItemRendererBase;
import de.dittner.siegmar.view.common.utils.FontName;

import flash.text.TextField;
import flash.text.TextFormat;

public class LogNoteItemRenderer extends ItemRendererBase {
	public function LogNoteItemRenderer() {
		super();
		percentWidth = 100;
	}

	private static const PAD:uint = Values.PT5;

	private var tf:TextField;
	override protected function createChildren():void {
		super.createChildren();
		tf = createTextField(new TextFormat(FontName.MYRIAD_MX, Values.PT16, 0x565656));
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		tf.htmlText = data is LogNote ? (data as LogNote).toHtmlString() : "";
	}

	override protected function measure():void {
		super.measure();
		tf.width = getExplicitOrMeasuredWidth() - 2 * PAD;
		measuredHeight = getActualHeight(tf);
	}

	private function getActualHeight(tf:TextField):Number {
		return tf.textHeight + 2 * PAD;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		tf.x = PAD;
		tf.width = w - 2 * PAD;
		tf.height = h - PAD;
		tf.y = h - tf.textHeight >> 1;
		if (getActualHeight(tf) != h) {
			invalidateSize();
			invalidateDisplayList();
		}
	}

}
}
