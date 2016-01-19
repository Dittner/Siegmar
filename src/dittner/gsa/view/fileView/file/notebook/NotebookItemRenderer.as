package dittner.gsa.view.fileView.file.notebook {
import dittner.gsa.domain.fileSystem.body.note.Note;
import dittner.gsa.view.common.utils.AppColors;
import dittner.gsa.view.common.utils.FontName;
import dittner.gsa.view.fileView.file.DraggableNoteItemRenderer;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class NotebookItemRenderer extends DraggableNoteItemRenderer {

	private static const TEXT_FORMAT:TextFormat = new TextFormat(FontName.GEORGIA_MX, 20, AppColors.TEXT_BLACK);

	private static const PAD:uint = 20;
	private static const SEP_COLOR:uint = 0;

	public function NotebookItemRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var textTf:TextField;

	private function get note():Note {
		return data as Note;
	}

	override protected function createChildren():void {
		super.createChildren();
		textTf = createMultilineTextField(TEXT_FORMAT, true);
		addChild(textTf);
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

		measuredWidth = unscaledWidth;

		textTf.width = measuredWidth - 2 * PAD - INDEX_COLUMN_WID + TEXT_DEFAULT_OFFSET;
		measuredMinHeight = measuredHeight = textTf.textHeight + 2 * PAD + TEXT_DEFAULT_OFFSET;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.lineStyle(1, SEP_COLOR, 0.25);
		g.moveTo(INDEX_COLUMN_WID, h - 1);
		g.lineTo(w, h - 1);

		textTf.x = PAD - TEXT_DEFAULT_OFFSET + INDEX_COLUMN_WID;
		textTf.y = PAD - TEXT_DEFAULT_OFFSET;
		adjustSize(textTf, w - textTf.x - PAD);
	}

}
}