package de.dittner.siegmar.view.fileView.file.album {
import dittner.async.IAsyncOperation;
import de.dittner.siegmar.view.common.utils.AppColors;
import de.dittner.siegmar.view.common.utils.FontName;
import de.dittner.siegmar.view.fileView.file.DraggableNoteItemRenderer;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

public class AlbumPhotoRenderer extends DraggableNoteItemRenderer {

	private static const TEXT_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, 14, AppColors.HELL_TÜRKIS, null, null, null, null, null, TextAlign.CENTER);

	private static const PAD:uint = 20;
	private static const SEP_COLOR:uint = 0x313645;
	private static const SIZE:uint = 250;

	public function AlbumPhotoRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var textTf:TextField;
	private var bitmap:Bitmap;

	override protected function createChildren():void {
		super.createChildren();
		bitmap = new Bitmap();
		addChild(bitmap);

		textTf = createMultilineTextField(TEXT_FORMAT, false);
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
		if (data) {
			textTf.text = data.title;
			bitmap.bitmapData = null;
			var op:IAsyncOperation = list.loadPhotoFunc(data.id);
			op.addCompleteCallback(photoLoaded);
		}
		else {
			textTf.text = "";
			bitmap.bitmapData = null;
		}
	}

	private function photoLoaded(op:IAsyncOperation):void {
		if (op.isSuccess && op.result is BitmapData) {
			bitmap.bitmapData = op.result;
			bitmap.smoothing = true;
			invalidateDisplayList();
		}
	}

	override protected function measure():void {
		if (!data || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = unscaledWidth;
		measuredMinHeight = measuredHeight = SIZE;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.lineStyle(1, SEP_COLOR);
		g.moveTo(INDEX_COLUMN_WID, h - 1);
		g.lineTo(w, h - 1);

		textTf.width = w - INDEX_COLUMN_WID;
		textTf.x = 5 - TEXT_DEFAULT_OFFSET + INDEX_COLUMN_WID;
		textTf.y = TEXT_DEFAULT_OFFSET;
		adjustSize(textTf, w - textTf.x - 10, 3 * PAD);

		bitmap.x = (w - bitmap.width >> 1) + INDEX_COLUMN_WID - PAD;
		bitmap.y = PAD + (h - bitmap.height >> 1);
	}

}
}