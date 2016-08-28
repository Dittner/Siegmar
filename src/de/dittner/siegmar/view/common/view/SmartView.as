package de.dittner.siegmar.view.common.view {
import de.dittner.siegmar.logging.CLog;
import de.dittner.siegmar.logging.LogCategory;

import flash.display.Graphics;
import flash.utils.getTimer;

import mx.events.FlexEvent;

public class SmartView extends ViewBase {
	public function SmartView() {
		super();
		percentWidth = 100;
		percentHeight = 100;
		horizontalCenter = 0;
		setStyle("backgroundAlpha", 0);
		addEventListener(FlexEvent.PREINITIALIZE, preinitializeHandler);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	public var bgColor:uint = 0xffFFff;
	public var bgColorEnabled:Boolean = false;

	protected var activationTriggered:Boolean = false;
	protected var preinitTime:int;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	protected function preinit():void {}

	override internal function invalidate(navigationPhase:String):void {
		if (navigationPhase == NavigationPhase.VIEW_ACTIVATE)
			triggerActivation();
		super.invalidate(navigationPhase);
	}

	protected function preinitializeHandler(event:FlexEvent):void {
		preinitTime = getTimer();
		preinit();
	}

	override protected function creationCompleteHandler(event:FlexEvent):void {
		super.creationCompleteHandler(event);
		triggerActivation();
	}

	protected function triggerActivation():void {
		if (activationTriggered) return;

		if (isActive && initialized) {
			activationTriggered = true;
			logCreationTime(getTimer() - preinitTime);
		}
	}

	protected function logCreationTime(time:int):void {
		var msg:String = fullName + " creation time:" + time + "ms";
		CLog.info(LogCategory.UI, "View: " + msg);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		if (bgColorEnabled) {
			g.beginFill(bgColor);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}
}
