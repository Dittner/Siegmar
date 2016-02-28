package dittner.siegmar.view.common.utils {
import flash.display.DisplayObject;
import flash.geom.Rectangle;

public class TapEventKit {
	public function TapEventKit() {}

	private static const doubleTapTargetHash:Object = {};
	public static function registerDoubleTapListener(target:DisplayObject, handler:Function):void {
		if (!target) throw new Error("Registering DoubleTap  require target!");
		if (!doubleTapTargetHash[target]) {
			doubleTapTargetHash[target] = new DoubleTap(target, handler);
		}
	}

	public static function unregisterDoubleTapListener(target:DisplayObject):void {
		if (doubleTapTargetHash[target]) {
			(doubleTapTargetHash[target] as DoubleTap).dispose();
			doubleTapTargetHash[target] = null;
			delete doubleTapTargetHash[target];
		}
	}

	private static const longTapTargetHash:Object = {};
	public static function registerLongTapListener(target:DisplayObject, handler:Function, mouseArea:Rectangle = null):void {
		if (!target) throw new Error("Registering LongTap  require target!");
		if (!longTapTargetHash[target]) {
			longTapTargetHash[target] = new LongTap(target, handler, mouseArea);
		}
	}

	public static function unregisterLongTapListener(target:DisplayObject):void {
		if (longTapTargetHash[target]) {
			(longTapTargetHash[target] as LongTap).dispose();
			longTapTargetHash[target] = null;
			delete longTapTargetHash[target];
		}
	}
}
}

import dittner.async.utils.clearDelay;
import dittner.async.utils.doLaterInMSec;
import dittner.async.utils.doLaterInSec;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

class DoubleTap {
	public function DoubleTap(target:DisplayObject, handler:Function) {
		this.target = target;
		this.handler = handler;

		target.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		target.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}

	private var hasFirstMouseDownFromDoubleClick:Boolean = false;
	private var target:DisplayObject;
	private var handler:Function;

	private function downHandler(event:MouseEvent):void {
		if (hasFirstMouseDownFromDoubleClick) {
			hasFirstMouseDownFromDoubleClick = false;
			if (handler != null) handler()
		}
		else {
			downPoint.x = event.stageX;
			downPoint.y = event.stageY;
			hasFirstMouseDownFromDoubleClick = true;
			doLaterInMSec(function ():void {hasFirstMouseDownFromDoubleClick = false;}, 200);
		}
	}

	private var downPoint:Point = new Point();
	private function mouseMoveHandler(event:MouseEvent):void {
		if (Math.abs(downPoint.x - event.stageX) > 30 || Math.abs(downPoint.y - event.stageY) > 30)
			hasFirstMouseDownFromDoubleClick = false;
	}

	public function dispose():void {
		target.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		handler = null;
	}

}
class LongTap {
	public function LongTap(target:DisplayObject, handler:Function, mouseArea:Rectangle) {
		this.target = target;
		this.handler = handler;
		this.mouseArea = mouseArea;

		target.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		target.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		target.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		target.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
	}

	private var target:DisplayObject;
	private var handler:Function;
	private var mouseArea:Rectangle;

	private var isProcessing:Boolean = false;
	private var doLaterID:Number = 0;
	private function downHandler(event:MouseEvent):void {
		if (!isProcessing && isDownValid(event.stageX, event.stageY)) {
			isProcessing = true;
			downPoint.x = event.stageX;
			downPoint.y = event.stageY;
			doLaterID = doLaterInSec(complete, 1);
		}
	}

	private function isDownValid(mouseX:Number, mouseY:Number):Boolean {
		if (!mouseArea) return true;
		return mouseX >= mouseArea.x && mouseX <= mouseArea.width && mouseY >= mouseArea.y && mouseY <= mouseArea.height;
	}

	private function upHandler(event:MouseEvent):void {
		resetProcess();
	}

	private function resetProcess():void {
		if (doLaterID) clearDelay(doLaterID);
		isProcessing = false;
	}

	private var downPoint:Point = new Point();
	private function mouseMoveHandler(event:MouseEvent):void {
		if (!isProcessing) return;
		if (Math.abs(downPoint.x - event.stageX) > 30 || Math.abs(downPoint.y - event.stageY) > 30)
			resetProcess();
	}

	private function mouseOutHandler(event:MouseEvent):void {
		if (isProcessing) resetProcess();
	}

	private function complete():void {
		if (isProcessing) {
			isProcessing = false;
			if (handler != null) handler();
		}
	}

	public function dispose():void {
		target.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		target.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		target.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		handler = null;
	}

}