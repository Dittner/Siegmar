package dittner.gsa.view.common.list {
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.geom.Point;

public class FileBodyList extends SelectableDataGroup {
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

	private static var tempPoint:Point = new Point();
	override protected function renderer_clickHandler(event:MouseEvent):void {
		tempPoint.x = event.localX;
		var point:Point = (event.target as DisplayObject).localToGlobal(tempPoint);
		point = globalToLocal(point);
		if (point.x <= clickableArea) super.renderer_clickHandler(event);
	}
}
}
