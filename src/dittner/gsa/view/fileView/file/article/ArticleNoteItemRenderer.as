package dittner.gsa.view.fileView.file.article {
import dittner.gsa.domain.fileSystem.body.note.ArticleNote;
import dittner.gsa.domain.fileSystem.body.note.NoteType;
import dittner.gsa.view.common.renderer.ItemRendererBase;
import dittner.gsa.view.common.utils.AppColors;
import dittner.gsa.view.common.utils.FontName;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

public class ArticleNoteItemRenderer extends ItemRendererBase {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.GEORGIA_MX, 30, AppColors.TEXT_BLACK, true, false, null, null, null, "center");
	private static const SUBTITLE_FORMAT:TextFormat = new TextFormat(FontName.GEORGIA_MX, 20, AppColors.TEXT_BLACK, true, false, null, null, null, "left");
	private static const EPIGRAPH_FORMAT:TextFormat = new TextFormat(FontName.GEORGIA_MX, 18, AppColors.TEXT_BLACK, false, true, null, null, null, "right");
	private static const CITATION_FORMAT:TextFormat = new TextFormat(FontName.GEORGIA_MX, 18, AppColors.TEXT_GRAY, false, false, null, null, null, "left");
	private static const TEXT_FORMAT:TextFormat = new TextFormat(FontName.GEORGIA_MX, 18, AppColors.TEXT_BLACK, false, false, null, null, null, "left");
	private static const INDEX_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 14, AppColors.HELL_TÜRKIS);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;
	private static const INDEX_COLUMN_WID:uint = 40;

	private static const PAD:uint = 10;
	private static const MAX_WIDTH:uint = 1000;

	public function ArticleNoteItemRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var textTf:TextField;
	private var indexTf:TextField;

	private function get note():ArticleNote {
		return data as ArticleNote;
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
		if (!note) {
			textTf.text = "";
			return;
		}
		switch (note.noteType) {
			case NoteType.TITLE :
				textTf.defaultTextFormat = TITLE_FORMAT;
				break;
			case NoteType.SUBTITLE :
				textTf.defaultTextFormat = SUBTITLE_FORMAT;
				break;
			case NoteType.EPIGRAPH :
				textTf.defaultTextFormat = EPIGRAPH_FORMAT;
				break;
			case NoteType.CITATION :
				textTf.defaultTextFormat = CITATION_FORMAT;
				break;
			default :
				textTf.defaultTextFormat = TEXT_FORMAT;
		}

		textTf.text = note.text;
	}

	override protected function measure():void {
		if (!note || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = unscaledWidth;

		textTf.width = Math.min(measuredWidth, MAX_WIDTH) - 2 * PAD - INDEX_COLUMN_WID + TEXT_DEFAULT_OFFSET;
		measuredMinHeight = measuredHeight = textTf.textHeight + 2 * PAD + TEXT_DEFAULT_OFFSET;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (w != measuredWidth) {
			invalidateSize();
			invalidateDisplayList();
			return;
		}

		g.beginFill(0xffFFff, selected ? .25 : 0);
		g.drawRect(0, 0, w, h - 1);
		g.endFill();

		indexTf.text = (itemIndex + 1).toString();
		adjustSize(indexTf, INDEX_COLUMN_WID);
		indexTf.y = PAD + TEXT_DEFAULT_OFFSET;

		textTf.x = (w - textTf.width >> 1) + INDEX_COLUMN_WID;
		textTf.y = PAD - TEXT_DEFAULT_OFFSET;
		textTf.height = textTf.textHeight + 5;
	}

}
}