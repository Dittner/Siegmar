package dittner.gsa.view.documentList {
import dittner.gsa.domain.fileSystem.IFolder;
import dittner.gsa.view.common.renderer.ItemRendererBase;
import dittner.gsa.view.common.utils.AppColors;
import dittner.gsa.view.common.utils.FontName;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

public class FolderItemRenderer extends ItemRendererBase {
	private static const ICON_ALPHA_OUT:Number = 0.5;
	private static const ICON_ALPHA_SELECTED:Number = 1;
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.GeorgiaMX, 20, AppColors.LILA);

	private static const VPAD:Number = 10;
	private static const HGAP:Number = 10;

	[Embed(source='/lock_icon.png')]
	protected static var FolderIconClass:Class;

	public function FolderItemRenderer() {
		super();
	}

	private var icon:DisplayObject;
	private var tf:TextField;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private function get folder():IFolder {
		return data as IFolder;
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
		icon = new FolderIconClass();
		icon.alpha = ICON_ALPHA_OUT;
		addChild(icon);

		tf = createTextField(TITLE_FORMAT);
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			tf.text = folder ? folder.title : "";
			icon.visible = folder.password;
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		measuredHeight = measuredMinHeight = icon ? icon.height + 2 * VPAD : 10;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 0.0001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		tf.alpha = icon.alpha = selected ? ICON_ALPHA_SELECTED : ICON_ALPHA_OUT;

		icon.x = HGAP;
		icon.y = (h - icon.height) / 2 + 2;

		tf.x = icon.x + icon.width + HGAP;
		tf.y = (h - tf.textHeight) / 2;
		tf.width = w - HGAP - tf.x;
	}

	override protected function overHandler(event:MouseEvent):void {
		if (!selected) {
			tf.alpha = icon.alpha = 1;
		}
	}

	override protected function outHandler(event:MouseEvent):void {
		if (!selected) {
			tf.alpha = icon.alpha = ICON_ALPHA_OUT;
		}
	}
}
}
