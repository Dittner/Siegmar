package dittner.siegmar.view.painting.renderer {
import dittner.siegmar.domain.fileSystem.body.picture.action.*;
import dittner.siegmar.view.common.list.SelectableDataGroupEvent;
import dittner.siegmar.view.common.renderer.*;
import dittner.siegmar.view.common.utils.AppColors;
import dittner.siegmar.view.common.utils.FontName;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.components.DataGroup;

public class PaintingActionRenderer extends ItemRendererBase {
	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 14, AppColors.TEXT_BLACK);
	private static const VPAD:uint = 5;
	private static const HPAD:uint = 5;

	[Embed(source="/assets/btn/delete_white_btn.png")]
	private static const DeleteBtnIconClass:Class;

	public function PaintingActionRenderer() {
		super();
		percentWidth = 100;
		addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		mouseChildren = false;
	}

	private var tf:TextField;
	private var deleteBtnIcon:DisplayObject;
	private var text:String = "";

	override public function set data(value:Object):void {
		super.data = value;
		if (data is PaintingAction)
			text = PaintingAction.keyToName((data as PaintingAction).key);
		else text = "";
	}

	override protected function createChildren():void {
		super.createChildren();
		tf = createTextField(FORMAT);
		addChild(tf);

		deleteBtnIcon = new DeleteBtnIconClass();
		deleteBtnIcon.visible = false;
		addChild(deleteBtnIcon);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			tf.text = text;
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		minHeight = 10;
		measuredHeight = tf.textHeight + 5 + 2 * VPAD;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			g.beginFill(AppColors.HELL_TÜRKIS);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else if (hovered) {
			g.beginFill(AppColors.HELL_TÜRKIS, .25);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}
		else {
			g.beginFill(0xffFFff, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}

		tf.x = HPAD;
		tf.y = VPAD;
		tf.width = w - 2 * HPAD;
		tf.height = h - 2 * VPAD;

		deleteBtnIcon.visible = selected;
		deleteBtnIcon.x = w - HPAD - 20;
		deleteBtnIcon.y = (h - 20 >> 1) + 1;
	}

	private function downHandler(event:MouseEvent):void {
		if (selected && event.localX >= deleteBtnIcon.x)
			if (parent is DataGroup) dispatchEvent(new SelectableDataGroupEvent(SelectableDataGroupEvent.REMOVE, data, itemIndex));
			else event.stopImmediatePropagation();
	}
}
}
