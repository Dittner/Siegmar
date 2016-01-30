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
		if (point.x <= clickableArea) super.renderer_clickHandler(event);
	}

	override protected function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		addEventListener(MouseEvent.RELEASE_OUTSIDE, outsideHandler);
		TapEventKit.registerLongTapListener(this, longTapPressed, clickableArea ? new Rectangle(0, 0, clickableArea, 2000) : null);
	}

	public function scrollToBottom():void {
		if (measuredHeight > height) verticalScrollPosition = measuredHeight - height;
	}

}
}
