package dittner.siegmar.view.fileList.list {
import dittner.siegmar.domain.fileSystem.header.FileHeader;
import dittner.siegmar.view.common.renderer.ItemRendererBase;
import dittner.siegmar.view.common.utils.AppColors;
import dittner.siegmar.view.common.utils.FontName;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class FolderRenderer extends ItemRendererBase {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.DARK_BLUE);

	protected static const HPAD:Number = 10;
	protected static const TEXT_PAd_LEFT:uint = 40;

	[Embed(source='/assets/file/dark_folder_icon.png')]
	private static var FolderIconClass:Class;
	private static var folderIcon:BitmapData;

	public function FolderRenderer() {
		super();
		doubleClickEnabled = true;
	}

	private var fileIcon:Bitmap;
	private var tf:TextField;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private function get fileHeader():FileHeader {
		return data as FileHeader;
	}

	override public function set data(value:Object):void {
		if (data != value) {
			super.data = value;
			invalidateProperties();
			invalidateSize();
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();
		if (!folderIcon) folderIcon = (new FolderIconClass()).bitmapData;

		fileIcon = new Bitmap(folderIcon);
		addChild(fileIcon);

		tf = createTextField(TITLE_FORMAT);
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged && fileHeader) {
			dataChanged = false;
			tf.text = fileHeader ? fileHeader.title : "";
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		measuredHeight = measuredMinHeight = 40;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		if (w == 0 || h == 0 || !fileHeader) return;

		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(AppColors.LILA, selected ? 0.3 : 0.0001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		fileIcon.x = HPAD;
		fileIcon.y = h - fileIcon.height >> 1;

		tf.x = TEXT_PAd_LEFT;
		tf.y = (h - tf.textHeight) / 2 - 2;
		adjustSize(tf, w - HPAD - tf.x);
	}
}
}