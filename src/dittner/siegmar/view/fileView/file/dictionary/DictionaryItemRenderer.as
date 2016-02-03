package dittner.siegmar.view.fileView.file.dictionary {
import dittner.siegmar.domain.fileSystem.body.note.TitledNote;
import dittner.siegmar.view.common.utils.AppColors;
import dittner.siegmar.view.common.utils.FontName;
import dittner.siegmar.view.fileView.file.DraggableNoteItemRenderer;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class DictionaryItemRenderer extends DraggableNoteItemRenderer {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 24, AppColors.TEXT_BLACK, true);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, 20, AppColors.TEXT_BLACK);

	private static const PAD:uint = 20;
	private static const GAP:uint = 10;
	private static const SEP_COLOR:uint = 0;

	public function DictionaryItemRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var titleTf:TextField;
	private var descriptionTf:TextField;

	//--------------------------------------
	//  note
	//--------------------------------------
	private function get note():TitledNote {
		return data as TitledNote;
	}

	override protected function createChildren():void {
		super.createChildren();
		descriptionTf = createMultilineTextField(DESCRIPTION_FORMAT, true);
		addChild(descriptionTf);
		titleTf = createMultilineTextField(TITLE_FORMAT, true);
		addChild(titleTf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			updateData();
		}
	}

	private function updateData():void {
		if (note) {
			titleTf.text = note.title;
			descriptionTf.text = note.text;
		}
		else {
			titleTf.text = "";
			descriptionTf.text = "";
		}
	}

	override protected function measure():void {
		if (!note || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = unscaledWidth;

		if (selected) {
			titleTf.width = descriptionTf.width = measuredWidth - 2 * PAD - INDEX_COLUMN_WID;
			measuredMinHeight = measuredHeight = titleTf.textHeight + descriptionTf.textHeight + 2 * PAD + GAP;
		}
		else {
			titleTf.width = measuredWidth - 2 * PAD - INDEX_COLUMN_WID;
			measuredMinHeight = measuredHeight = titleTf.textHeight + 2 * PAD;
		}
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.lineStyle(1, SEP_COLOR, 0.25);
		g.moveTo(INDEX_COLUMN_WID, h - 1);
		g.lineTo(w, h - 1);

		descriptionTf.visible = selected;

		titleTf.x = PAD - TEXT_DEFAULT_OFFSET + INDEX_COLUMN_WID;
		titleTf.y = PAD - TEXT_DEFAULT_OFFSET;
		adjustSize(titleTf, w - titleTf.x - PAD);

		if (descriptionTf.visible) {
			descriptionTf.x = PAD - TEXT_DEFAULT_OFFSET + INDEX_COLUMN_WID;
			descriptionTf.y = PAD + titleTf.textHeight + GAP - TEXT_DEFAULT_OFFSET;
			adjustSize(descriptionTf, w - descriptionTf.x - PAD);
		}
	}

}
}