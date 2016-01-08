package dittner.gsa.view.fileList.list {
import dittner.gsa.domain.fileSystem.header.FileHeader;
import dittner.gsa.view.common.renderer.ItemRendererBase;
import dittner.gsa.view.common.utils.AppColors;
import dittner.gsa.view.common.utils.FontName;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class FileHeaderRenderer extends ItemRendererBase {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.LILA);

	private static const HPAD:Number = 10;
	private static const TEXT_PAd_LEFT:uint = 40;

	[Embed(source='/assets/file/folder_icon.png')]
	protected static var FolderIconClass:Class;

	public function FileHeaderRenderer() {
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
		fileIcon = new Bitmap();
		addChild(fileIcon);

		tf = createTextField(TITLE_FORMAT);
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged && fileHeader) {
			dataChanged = false;
			tf.text = fileHeader ? fileHeader.title : "";
			fileIcon.bitmapData = getIcon();
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
		g.beginFill(AppColors.LILA, selected ? 0.2 : 0.0001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		fileIcon.x = HPAD;
		fileIcon.y = h - fileIcon.height >> 1;

		tf.x = TEXT_PAd_LEFT;
		tf.textColor = fileHeader.textColor;
		tf.y = (h - tf.textHeight) / 2 - 2;
		adjustSize(tf, w - HPAD - tf.x);
	}

	private static var folderIcon:BitmapData;
	private static var iconsHash:Object = {};
	private function getIcon():BitmapData {
		if (fileHeader.isFolder) {
			if (!folderIcon) folderIcon = (new FolderIconClass()).bitmapData;
			return folderIcon;
		}
		if (!iconsHash[fileHeader.symbol]) {
			var fileIconRender:DocIconRender = new DocIconRender(fileHeader.textColor, fileHeader.symbol);
			iconsHash[fileHeader.symbol] = fileIconRender.render();
		}
		return iconsHash[fileHeader.symbol];
	}
}
}