package dittner.siegmar.view.common.list {
import dittner.siegmar.domain.fileSystem.body.links.BookLinksBody;
import dittner.siegmar.view.common.utils.TapEventKit;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

public class FileBodyList extends ReordableList {
	public function FileBodyList() {
		super();
	}

	//--------------------------------------
	//  loadPhotoFunc
	//--------------------------------------
	private var _loadPhotoFunc:Function;
	public function get loadPhotoFunc():Function {return _loadPhotoFunc;}
	public function set loadPhotoFunc(value:Function):void {
		if (_loadPhotoFunc != value) {
			_loadPhotoFunc = value;
		}
	}

	//--------------------------------------
	//  clickArea
	//--------------------------------------
	private var _clickableArea:Number = 0;
	public function get clickableArea():Number {return _clickableArea;}
	public function set clickableArea(value:Number):void {
		if (_clickableArea != value) {
			_clickableArea = value;
		}
	}

	//--------------------------------------
	//  bookLinksBody
	//--------------------------------------
	private var _bookLinksBody:BookLinksBody;
	[Bindable("bookLinksBodyChanged")]
	public function get bookLinksBody():BookLinksBody {return _bookLinksBody;}
	public function set bookLinksBody(value:BookLinksBody):void {
		if (_bookLinksBody != value) {
			_bookLinksBody = value;
			dispatchEvent(new Event("bookLinksBodyChanged"));
		}
	}

	private static var tempPoint:Point = new Point();
	override protected function renderer_clickHandler(event:MouseEvent):void {
		tempPoint.x = event.localX;
		var point:Point = (event.target as DisplayObject).localToGlobal(tempPoint);
		point = globalToLocal(point);
		if (clickableArea == 0 || point.x <= clickableArea) super.renderer_clickHandler(event);
	}

	override protected function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		addEventListener(MouseEvent.RELEASE_OUTSIDE, outsideHandler);
		TapEventKit.registerLongTapListener(this, longTapPressed, clickableArea ? new Rectangle(0, 0, clickableArea, 2000) : null);
	}

	//чтобы после удаления/добавления элемента в коллекцию скрол позиция не сбрасывалась
	override public function set verticalScrollPosition(value:Number):void {
		value = value < 0 ? 0 : value;
		if (value == 0) {
			if (verticalScrollPosition < 400)
				super.verticalScrollPosition = value;
		}
		else {
			super.verticalScrollPosition = value;
		}
	}
}
}
