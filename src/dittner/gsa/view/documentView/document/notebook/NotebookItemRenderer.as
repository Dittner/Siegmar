package dittner.gsa.view.documentView.document.notebook {
import dittner.gsa.domain.fileSystem.body.note.Note;
import dittner.gsa.view.common.renderer.ItemRendererBase;
import dittner.gsa.view.common.utils.AppColors;
import dittner.gsa.view.common.utils.FontName;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

public class NotebookItemRenderer extends ItemRendererBase {

	private static const TEXT_FORMAT:TextFormat = new TextFormat(FontName.TAHOMA_MX, 20, AppColors.TEXT_BLACK);
	private static const INDEX_FORMAT:TextFormat = new TextFormat(FontName.TAHOMA_MX, 14, AppColors.HELL_TÜRKIS);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;
	private static const INDEX_COLUMN_WID:uint = 40;

	private static const PAD:uint = 20;
	private static const SEP_COLOR:uint = 0;

	public function NotebookItemRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var textTf:TextField;
	private var indexTf:TextField;

	private function get note():Note {
		return data as Note;
	}

	override protected function createChildren():void {
		super.createChildren();
		textTf = createMultilineTextField(TEXT_FORMAT, true);
		addChild(textTf);
		INDEX_FORMAT.align = TextAlign.CENTER;
		indexTf = createTextField(INDEX_FORMAT);
		addChild(indexTf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			updateData();
		}
	}

	private function updateData():void {
		textTf.text = note ? note.text : "";
	}

	override protected function measure():void {
		if (!note || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = parent.width;

		textTf.width = measuredWidth - 2 * PAD - INDEX_COLUMN_WID;
		measuredMinHeight = measuredHeight = textTf.textHeight + 2 * PAD;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			g.beginFill(AppColors.ITEM_SELECTED);
			g.drawRect(0, 0, INDEX_COLUMN_WID, h);
			g.endFill();
		}

		indexTf.text = (itemIndex + 1).toString();
		adjustSize(indexTf, INDEX_COLUMN_WID);
		indexTf.y = PAD + TEXT_DEFAULT_OFFSET;

		g.lineStyle(1, SEP_COLOR, 0.25);
		g.moveTo(INDEX_COLUMN_WID, h - 1);
		g.lineTo(w, h - 1);

		textTf.x = PAD - TEXT_DEFAULT_OFFSET + INDEX_COLUMN_WID;
		textTf.y = PAD - TEXT_DEFAULT_OFFSET;
		adjustSize(textTf, w - textTf.x - PAD);
	}

}
}