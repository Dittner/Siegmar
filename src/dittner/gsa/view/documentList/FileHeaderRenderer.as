package dittner.gsa.view.documentList {
import dittner.gsa.domain.fileSystem.GSAFileHeader;
import dittner.gsa.domain.fileSystem.IGSAFile;
import dittner.gsa.view.common.renderer.ItemRendererBase;
import dittner.gsa.view.common.utils.AppColors;
import dittner.gsa.view.common.utils.FontName;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class FileHeaderRenderer extends ItemRendererBase {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.GeorgiaMX, 18, AppColors.LILA);

	private static const HGAP:Number = 10;

	[Embed(source='/lock_icon.png')]
	protected static var LockIconClass:Class;

	[Embed(source='/folder_icon.png')]
	protected static var FolderIconClass:Class;

	[Embed(source='/locked_folder_icon.png')]
	protected static var LockedFolderIconClass:Class;

	public function FileHeaderRenderer() {
		super();
	}

	private var lockedFolderIcon:DisplayObject;
	private var folderIcon:DisplayObject;
	private var lockIcon:DisplayObject;
	private var tf:TextField;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private function get file():IGSAFile {
		return data as IGSAFile;
	}

	private function get fileHeader():GSAFileHeader {
		return file ? file.header : null;
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
			folderIcon.visible = fileHeader.password;
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		measuredHeight = measuredMinHeight = folderIcon.height + 10;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		if (w == 0 || h == 0 || !file) return;

		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(file.isFolder ? AppColors.BRAUN : AppColors.LILA, selected ? 0.2 : 0.0001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		lockedFolderIcon.x = folderIcon.x = HGAP;
		lockedFolderIcon.y = folderIcon.y = (h - folderIcon.height) / 2;
		lockedFolderIcon.visible = file.isFolder && fileHeader.password;
		folderIcon.visible = !lockedFolderIcon.visible;

		lockIcon.x = folderIcon.width + 2 * HGAP;
		lockIcon.y = (h - lockIcon.height) / 2;
		lockIcon.visible = !file.isFolder && fileHeader.password;

		tf.x = folderIcon.x + folderIcon.width + HGAP;
		tf.textColor = file.isFolder ? AppColors.BRAUN : AppColors.LILA;
		tf.y = (h - tf.textHeight) / 2 - 2;
		tf.width = w - HGAP - tf.x;
	}

}
}
