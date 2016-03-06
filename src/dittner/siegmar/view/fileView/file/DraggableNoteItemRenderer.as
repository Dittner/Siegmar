package dittner.siegmar.view.fileView.file {
import dittner.siegmar.domain.fileSystem.body.links.BookLinksBody;
import dittner.siegmar.view.common.list.DragItemInfo;
import dittner.siegmar.view.common.list.FileBodyList;
import dittner.siegmar.view.common.list.IDraggable;
import dittner.siegmar.view.common.renderer.ItemRendererBase;
import dittner.siegmar.view.common.utils.AppColors;
import dittner.siegmar.view.common.utils.FontName;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

public class DraggableNoteItemRenderer extends ItemRendererBase implements IDraggable {

	private static const INDEX_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 14, AppColors.HELL_TÜRKIS);

	protected static const TEXT_DEFAULT_OFFSET:uint = 2;
	public static const INDEX_COLUMN_WID:uint = 40;

	protected static const PAD:uint = 10;

	public function DraggableNoteItemRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	protected var indexTf:TextField;

	protected function get list():FileBodyList {
		return parent is FileBodyList ? parent as FileBodyList : null;
	}

	//--------------------------------------
	//  links
	//--------------------------------------
	protected function get links():BookLinksBody {
		return list && list.bookLinksBody ? list.bookLinksBody : null;
	}

	//--------------------------------------
	//  dragItemInfo
	//--------------------------------------
	private var _dragItemInfo:DragItemInfo;
	public function get dragItemInfo():DragItemInfo {return _dragItemInfo;}
	public function set dragItemInfo(value:DragItemInfo):void {
		_dragItemInfo = value;
		invalidateDisplayList();
	}

	override protected function createChildren():void {
		super.createChildren();
		INDEX_FORMAT.align = TextAlign.CENTER;
		indexTf = createTextField(INDEX_FORMAT);
		addChild(indexTf);
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

		var bgColor:uint;
		var bgAlpha:Number;

		if (dragItemInfo && dragItemInfo.data == data) {
			bgColor = 0;
			bgAlpha = 0.25;
		}
		else if (dragItemInfo && dragItemInfo.data != data && hovered) {
			bgColor = AppColors.HELL_TÜRKIS;
			bgAlpha = 0.5;
		}
		else if (selected) {
			bgColor = 0xffFFff;
			bgAlpha = .15;
		}
		else {
			bgColor = 0xffFFff;
			bgAlpha = 0;
		}

		g.beginFill(bgColor, bgAlpha);
		g.drawRect(0, 0, w, h - 1);
		g.endFill();

		if (dragItemInfo && dragItemInfo.data != data && hovered) {
			g.beginFill(bgColor, 1);
			if (itemIndex < dragItemInfo.index) g.drawRect(0, 0, INDEX_COLUMN_WID, 5);
			else g.drawRect(0, h - 5, INDEX_COLUMN_WID, 5);
			g.endFill();
		}

		indexTf.text = (itemIndex + 1).toString();
		adjustSize(indexTf, INDEX_COLUMN_WID);
		indexTf.y = PAD + TEXT_DEFAULT_OFFSET;
	}

}
}