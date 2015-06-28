package dittner.gsa.view.documentView.document.dictionary {
import dittner.gsa.domain.fileSystem.body.note.TitledNote;
import dittner.gsa.view.common.renderer.ItemRendererBase;
import dittner.gsa.view.common.utils.AppColors;
import dittner.gsa.view.common.utils.FontName;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class DictionaryItemRenderer extends ItemRendererBase {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.TAHOMA_MX, 26, AppColors.TEXT_BLACK, true);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.TAHOMA_MX, 20, AppColors.TEXT_BLACK);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const PAD:uint = 20;
	private static const GAP:uint = 10;
	private static const SEP_COLOR:uint = 0xc5c5cd;

	public function DictionaryItemRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var titleTf:TextField;
	private var descriptionTf:TextField;

	private function get note():TitledNote {
		return data as TitledNote;
	}

	override protected function createChildren():void {
		super.createChildren();
		descriptionTf = createMultilineTextField(DESCRIPTION_FORMAT);
		addChild(descriptionTf);
		titleTf = createMultilineTextField(TITLE_FORMAT);
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

		measuredWidth = parent.width;

		if (selected) {
			titleTf.width = descriptionTf.width = measuredWidth - 2 * PAD;
			measuredMinHeight = measuredHeight = titleTf.textHeight + descriptionTf.textHeight + 2 * PAD + GAP;
		}
		else {
			titleTf.width = measuredWidth - 2 * PAD;
			measuredMinHeight = measuredHeight = titleTf.textHeight + 2 * PAD;
		}
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			g.beginFill(AppColors.ITEM_SELECTED);
			g.drawRect(0, 0, 10, h);
			g.endFill();
		}

		descriptionTf.visible = selected;

		g.lineStyle(1, SEP_COLOR, 0.5);
		g.moveTo(PAD, h - 1);
		g.lineTo(w - 2 * PAD, h - 1);

		titleTf.x = titleTf.y = PAD - TEXT_DEFAULT_OFFSET;

		if (descriptionTf.visible) {
			descriptionTf.x = PAD - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = PAD + titleTf.textHeight + GAP - TEXT_DEFAULT_OFFSET;
		}
	}

}
}