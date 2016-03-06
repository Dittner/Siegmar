package dittner.siegmar.view.common.preloader {
import dittner.siegmar.view.common.utils.AppColors;

import flash.desktop.NativeApplication;
import flash.display.Bitmap;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;
import flash.utils.getTimer;

import flashx.textLayout.formats.TextAlign;

import mx.preloaders.SparkDownloadProgressBar;

public final class AppPreloader extends SparkDownloadProgressBar {

	[Embed(source="/bg_pattern.png")]
	private var BgClass:Class;

	private const DELAY_DURATION:int = 1000;//ms

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function AppPreloader(color:uint = 0xFFffFF):void {
		var nativeApplication:NativeApplication = NativeApplication.nativeApplication;
		nativeApplication.addEventListener(Event.ACTIVATE, nativeApplication_activateHandler);
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}

	private static var positionUpdated:Boolean = false;
	private function nativeApplication_activateHandler(event:Event):void {
		if (!positionUpdated) {
			positionUpdated = true;
			NativeApplication.nativeApplication.activeWindow.x = (Capabilities.screenResolutionX - NativeApplication.nativeApplication.activeWindow.width) / 2;
			NativeApplication.nativeApplication.activeWindow.y = 0;
		}
	}

	private var progressField:TextField;
	private var startTime:int = 0;
	private var preloadingComplete:Boolean = false;
	private var progressTimer:Timer;
	private var startDelayTime:int = 0;
	private var elapsedTime:int = 0;
	private var progress:Number = 0;

	private function addedToStage(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

		var bg:Bitmap = new BgClass();
		var g:Graphics = graphics;
		g.clear();
		g.beginBitmapFill(bg.bitmapData);
		g.drawRect(0, 0, stage.fullScreenWidth * 2, stage.fullScreenHeight * 2);

		progressField = new TextField();
		progressField.selectable = false;
		progressField.width = 100;
		progressField.height = 100;
		progressField.embedFonts = false;
		progressField.defaultTextFormat = new TextFormat("_sans", 20, AppColors.HELL_TÜRKIS, null, null, null, null, null, TextAlign.CENTER);
		addChild(progressField);

		startTime = getTimer();
		progressTimer = new Timer(100, 0);
		progressTimer.addEventListener(TimerEvent.TIMER, progressTimerHandler);
		progressTimer.start();
	}

	private function progressTimerHandler(event:TimerEvent):void {
		elapsedTime = getTimer() - startTime;

		if (startDelayTime == 0) startDelayTime = elapsedTime;
		progress = Math.min((elapsedTime - startDelayTime) / DELAY_DURATION, 1);

		if (preloadingComplete && progress == 1) {
			progressTimer.stop();
			notifyComplete();
		}

		progressField.text = Math.round((progress * 100)) + "%";
		progressField.width = 100;
		if (progressField.y == 0 && stage) {
			progressField.y = (stage.stageHeight - progressField.height >> 1);
			progressField.x = (stage.stageWidth - progressField.width >> 1);
		}
	}

	override protected function createChildren():void {}

	override protected function setInitProgress(completed:Number, total:Number):void {}

	override protected function initCompleteHandler(event:Event):void {
		preloadingComplete = true;
	}

	private function notifyComplete():void {
		if (preloadingComplete) {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}

}
}