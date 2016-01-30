package dittner.siegmar.view.fileList.favorites {
import dittner.siegmar.view.common.list.SelectableDataGroupEvent;
import dittner.siegmar.view.fileList.list.FileHeaderRenderer;

import flash.display.DisplayObject;
import flash.events.MouseEvent;

import spark.components.DataGroup;

public class FavoriteFileHeaderRenderer extends FileHeaderRenderer {

	[Embed(source="/assets/btn/delete_white_btn.png")]
	private static const DeleteBtnIconClass:Class;

	public function FavoriteFileHeaderRenderer() {
		super();
		percentWidth = 100;
		addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
	}

	private var deleteBtnIcon:DisplayObject;

	override protected function createChildren():void {
		super.createChildren();
		deleteBtnIcon = new DeleteBtnIconClass();
		deleteBtnIcon.visible = false;
		addChild(deleteBtnIcon);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

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
