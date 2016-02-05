package dittner.siegmar.view.common.busyIndicator {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.core.UIComponent;

[Event(name="renderComplete", type="flash.events.Event")]
public class BusyIndicator extends UIComponent {

	public static const RENDER_DELAY:int = 1000;//ms

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	public function BusyIndicator() {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	[Embed(source='/swf/busyIndicator.swf')]
	protected static var indicatorClass:Class;

	protected var indicatorBg:Sprite;
	protected var indicator:MovieClip;

	private var renderTimer:Timer;

	//----------------------------------------------------------------------------------------------
	//
	//  Overriden
	//
	//----------------------------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();
		indicatorBg = new Sprite();
		indicator = new indicatorClass();
		updateIndicatorPlay();
		addChild(indicatorBg);
		addChild(indicator);
	}

	override protected function measure():void {
		super.measure();
		measuredWidth = 200;
		measuredHeight = 200;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		indicator.x = w - indicator.width >> 1;
		indicator.y = h - indicator.height >> 1;

		indicatorBg.graphics.clear();
		indicatorBg.graphics.beginFill(0xffFFff, 0);
		indicatorBg.graphics.drawRect(0, 0, w - 1, h - 1);
		indicatorBg.graphics.endFill();

		if (_visibleChanged) updateIndicatorPlay();
	}

	private var _visibleChanged:Boolean;
	private var _visible:Boolean = true;
	override public function set visible(value:Boolean):void {
		super.visible = value;
		if (_visible != value) {
			_visible = value;
			_visibleChanged = true;
			invalidateDisplayList();
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Protected methods
	//
	//--------------------------------------------------------------------------

	protected function updateIndicatorPlay():void {
		if (indicator) {
			if (_visible) {
				if (hasEventListener("renderComplete")) {
					if (renderTimer == null) {
						renderTimer = new Timer(RENDER_DELAY, 1);
						renderTimer.addEventListener(TimerEvent.TIMER_COMPLETE, renderDelayCompleteHandler)
					}
					renderTimer.reset();
					renderTimer.start();
				}
				indicator.play();
			}
			else {
				if (renderTimer && renderTimer.running) renderTimer.stop();
				indicator.stop();
			}
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Handlers
	//
	//--------------------------------------------------------------------------

	private function renderDelayCompleteHandler(event:TimerEvent):void {
		dispatchEvent(new Event("renderComplete"));
	}
}
}
