package dittner.gsa.view.documentList.list {
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.FileType;
import dittner.gsa.view.common.renderer.ItemRendererBase;
import dittner.gsa.view.common.utils.AppColors;
import dittner.gsa.view.common.utils.FontName;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class FileHeaderRenderer extends ItemRendererBase {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.TAHOMA_MX, 20, AppColors.LILA);

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
		if (dataChanged) {
			dataChanged = false;
			tf.text = fileHeader ? fileHeader.title : "";
			fileIcon.bitmapData = getIcon(fileHeader.fileType);
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
		tf.textColor = getTextColor(fileHeader.fileType);
		tf.y = (h - tf.textHeight) / 2 - 2;
		adjustSize(tf, w - HPAD - tf.x);
	}

	private function getTextColor(fileType:uint):uint {
		switch (fileType) {
			case FileType.ARTICLE :
				return AppColors.DOC_ARTICLE;
			case FileType.DICTIONARY :
				return AppColors.DOC_DICTIONARY;
			case FileType.NOTEBOOK :
				return AppColors.DOC_NOTEBOOK;
			case FileType.PICTURE :
				return AppColors.DOC_PICTURE;
			default :
				return AppColors.FOLDER;
		}
	}

	private static var folderIcon:BitmapData;
	private static var dicIcon:BitmapData;
	private static var noteIcon:BitmapData;
	private static var pictureIcon:BitmapData;
	private function getIcon(fileType:uint):BitmapData {
		switch (fileType) {
			case FileType.ARTICLE :
				return null;
			case FileType.DICTIONARY :
				if (!dicIcon) {
					var dicIconRender:DocIconRender = new DocIconRender(getTextColor(fileType), "W");
					dicIcon = dicIconRender.render();
				}
				return dicIcon;
			case FileType.NOTEBOOK :
				if (!noteIcon) {
					var noteIconRender:DocIconRender = new DocIconRender(getTextColor(fileType), "N");
					noteIcon = noteIconRender.render();
				}
				return noteIcon;
			case FileType.PICTURE :
				if (!pictureIcon) {
					var pictureIconRender:DocIconRender = new DocIconRender(getTextColor(fileType), "B");
					pictureIcon = pictureIconRender.render();
				}
				return pictureIcon;
			case FileType.FOLDER :
				if (!folderIcon) {
					folderIcon = (new FolderIconClass()).bitmapData;
				}
				return folderIcon;
			default :
				return null;
		}
	}

}
}

import dittner.gsa.view.common.utils.FontName;
import dittner.gsa.view.common.utils.TextFieldFactory;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

class DocIconRender extends Sprite {
	private static const RAD:uint = 11;

	public function DocIconRender(color:uint, letter:String) {
		tf = TextFieldFactory.create(new TextFormat(FontName.ARIAL_MX, 12, color, null, null, null, null, null, TextAlign.CENTER));
		addChild(tf);
		tf.text = letter;
		var g:Graphics = graphics;
		g.beginFill(0, 1);
		g.drawCircle(RAD, RAD, RAD);
		g.endFill();
		tf.width = 21;
		tf.y = (2 * RAD - tf.textHeight >> 1) - 1;
	}

	public function render():BitmapData {
		var bd:BitmapData = new BitmapData(2 * RAD, 2 * RAD, true, 0);
		bd.draw(this, null, null, null, null, true);
		return bd;
	}

	private var tf:TextField;

}