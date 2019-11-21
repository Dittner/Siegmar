package de.dittner.siegmar.view.fileView.form.body {
import de.dittner.siegmar.model.domain.fileSystem.body.links.BookLink;
import de.dittner.siegmar.view.common.renderer.ItemRendererBase;
import de.dittner.siegmar.view.common.utils.AppColors;
import de.dittner.siegmar.view.common.utils.FontName;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class ArticleBodyBookLinkRenderer extends ItemRendererBase {

	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 14, AppColors.TEXT_BLACK);

	private static const VPAD:uint = 10;
	private static const HPAD:uint = 5;

	public function ArticleBodyBookLinkRenderer() {
		super();
		percentWidth = 100;
	}

	private var tf:TextField;

	private function get bookLink():BookLink {
		return data as BookLink;
	}

	override protected function createChildren():void {
		super.createChildren();
		tf = createMultilineTextField(FORMAT);
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			tf.text = bookLink ? bookLink.toString() : "";
		}
	}

	override protected function measure():void {
		measuredWidth = Math.max(50, parent.width);
		tf.width = measuredWidth - 2 * HPAD;
		measuredHeight = tf.textHeight + 2 * VPAD + 5;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		if (w != measuredWidth || h != measuredHeight) {
			invalidateSize();
			invalidateDisplayList();
			return;
		}

		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			g.beginFill(AppColors.HELL_TÜRKIS);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else if (hovered) {
			g.beginFill(AppColors.HELL_TÜRKIS, .25);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}
		else {
			g.beginFill(0xffFFff, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}

		tf.x = HPAD;
		tf.y = VPAD;
		tf.width = w - 2 * HPAD;
		tf.height = h - 2 * VPAD;
	}

}
}