package dittner.siegmar.utils.delay {
import flash.display.Stage;
import flash.events.Event;

import mx.core.FlexGlobals;

public class FrameTimer {
	public function FrameTimer(delayFrames:uint, callbackFunc:Function) {
		this.delayFrames = delayFrames == 0 ? 1 : delayFrames;
		completeFunc = callbackFunc;
		if (completeFunc == null) throw new Error("callbackFunc == null!");
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	private var delayFrames:uint;
	private var completeFunc:Function;
	private var wentFrames:uint = 0;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  running
	//--------------------------------------
	private var _running:Boolean = false;
	public function get running():Boolean {return _running;}
	private function setRunning(value:Boolean):void {
		if (_running != value) {
			_running = value;
		}
	}

	//--------------------------------------
	//  stage
	//--------------------------------------
	private function get stage():Stage {
		return FlexGlobals.topLevelApplication.stage;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function appAddedToStage(event:Event):void {
		FlexGlobals.topLevelApplication.removeEventListener(Event.ADDED_TO_STAGE, appAddedToStage);
		waitingStage = false;
		start();
	}

	public function reset():void {
		wentFrames = 0;
	}

	private var waitingStage:Boolean = false;
	public function start():void {
		if (!running) {
			if (stage) {
				setRunning(true);
				stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			else if (!waitingStage) {
				waitingStage = true;
				FlexGlobals.topLevelApplication.addEventListener(Event.ADDED_TO_STAGE, appAddedToStage);
			}
		}
	}

	public function stop():void {
		if (running) {
			setRunning(false);
			wentFrames = 0;
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
	}

	private function enterFrameHandler(event:Event):void {
		wentFrames++;
		if (wentFrames >= delayFrames) {
			setRunning(false);
			stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			wentFrames = 0;
			completeFunc();
		}
	}
}
}
