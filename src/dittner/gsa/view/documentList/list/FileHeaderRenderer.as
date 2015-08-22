package dittner.gsa.view.documentList.list {
import dittner.gsa.domain.fileSystem.FileHeader;
import dittner.gsa.domain.fileSystem.FileType;
import dittner.gsa.view.common.renderer.ItemRendererBase;
import dittner.gsa.view.common.utils.AppColors;
import dittner.gsa.view.common.utils.FontName;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class FileHeaderRenderer extends ItemRendererBase {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.TAHOMA_MX, 20, AppColors.LILA);

	private static const HGAP:Number = 10;

	[Embed(source='/assets/file/lock_icon.png')]
	protected static var LockIconClass:Class;

	[Embed(source='/assets/file/folder_icon.png')]
	protected static var FolderIconClass:Class;

	[Embed(source='/assets/file/dic_icon.png')]
	protected static var DicIconClass:Class;

	[Embed(source='/assets/file/note_icon.png')]
	protected static var NoteIconClass:Class;

	[Embed(source='/assets/file/locked_folder_icon.png')]
	protected static var LockedFolderIconClass:Class;

	public function FileHeaderRenderer() {
		super();
		doubleClickEnabled = true;
	}

	private var lockedFolderIcon:DisplayObject;
	private var fileIcon:Bitmap;
	private var folderIcon:Bitmap;
	private var lockIcon:Bitmap;
	private var tf:TextField;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private function get fileHeader():FileHeader {
		return data as FileHeader;
	}

	private function get isFolder():Boolean {
		return fileHeader && fileHeader.isFolder;
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
		folderIcon = new FolderIconClass();
		addChild(folderIcon);

		fileIcon = new Bitmap();
		addChild(fileIcon);

		lockIcon = new LockIconClass();
		addChild(lockIcon);

		lockedFolderIcon = new LockedFolderIconClass();
		addChild(lockedFolderIcon);

		tf = createTextField(TITLE_FORMAT);
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			tf.text = fileHeader ? fileHeader.title : "";
			if (isFolder) folderIcon.visible = fileHeader.password;
			else fileIcon.bitmapData = getIcon(fileHeader.fileType);
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		measuredHeight = measuredMinHeight = folderIcon.height + 10;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		if (w == 0 || h == 0 || !fileHeader) return;

		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(isFolder ? AppColors.BRAUN : AppColors.LILA, selected ? 0.2 : 0.0001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		lockedFolderIcon.x = folderIcon.x = fileIcon.x = HGAP;
		lockedFolderIcon.y = folderIcon.y = fileIcon.y = (h - folderIcon.height) / 2;
		if (isFolder) {
			fileIcon.visible = false;
			lockedFolderIcon.visible = fileHeader.password;
			folderIcon.visible = !lockedFolderIcon.visible;
		}
		else {
			fileIcon.visible = true;
			lockedFolderIcon.visible = false;
			folderIcon.visible = false;
		}

		lockIcon.x = folderIcon.width + 2 * HGAP;
		lockIcon.y = (h - lockIcon.height) / 2;
		lockIcon.visible = !isFolder && fileHeader.password;

		tf.x = folderIcon.x + folderIcon.width + HGAP;
		tf.textColor = getTextColor(fileHeader.fileType);
		tf.y = (h - tf.textHeight) / 2 - 2;
		adjustSize(tf, w - HGAP - tf.x);
	}

	private function getTextColor(fileType:uint):uint {
		switch (fileType) {
			case FileType.ARTICLE :
				return AppColors.DOC_ARTICLE;
			case FileType.DICTIONARY :
				return AppColors.DOC_DICTIONARY;
			case FileType.NOTEBOOK :
				return AppColors.DOC_NOTEBUCH;
			default :
				return AppColors.BRAUN;
		}
	}

	private static var dicIcon:BitmapData;
	private static var noteIcon:BitmapData;
	private function getIcon(fileType:uint):BitmapData {
		switch (fileType) {
			case FileType.ARTICLE :
				return null;
			case FileType.DICTIONARY :
				if (!dicIcon) dicIcon = (new DicIconClass).bitmapData;
				return dicIcon;
			case FileType.NOTEBOOK :
				if (!noteIcon) noteIcon = (new NoteIconClass).bitmapData;
				return noteIcon;
			default :
				return null;
		}
	}

}
}