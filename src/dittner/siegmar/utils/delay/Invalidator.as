package dittner.siegmar.utils.delay {
import flash.events.TimerEvent;

public class Invalidator {

	private static const DELAYED_FRAMES:Number = 3;

	private static var validateTimer:FrameTimer = new FrameTimer(DELAYED_FRAMES, validate);
	private static var funcQueue:Array = [];

	public static function add(func:Function):void {
		if (func == null) return;
		var ind:int = getFuncInd(func);
		if (ind == -1) {
			funcQueue.push(func);
		}
		//сохраняем последовательность вызываемых ф-ий в порядке очереди
		else if (ind != (funcQueue.length - 1)) {
			funcQueue.splice(ind, 1);
			funcQueue.push(func);
		}

		if (!validateTimer.running) {
			validateTimer.reset();
			validateTimer.start();
		}
	}

	private static function getFuncInd(func:Function):int {
		for (var i:int = 0; i < funcQueue.length; i++) if (funcQueue[i] == func) return i;
		return -1;
	}

	private static function validate(event:TimerEvent = null):void {
		var funcs:Array = funcQueue.splice(0, funcQueue.length);
		for each (var func:Function in funcs) func();
		if (funcQueue.length == 0) validateTimer.stop();
	}
}
}
