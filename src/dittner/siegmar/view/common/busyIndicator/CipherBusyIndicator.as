package dittner.siegmar.view.common.busyIndicator {
import dittner.siegmar.utils.delay.invalidateOf;
import dittner.siegmar.view.common.utils.FontName;
import dittner.siegmar.view.common.utils.TextFieldFactory;

import flash.display.Graphics;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

public class CipherBusyIndicator extends UIComponent {
	public function CipherBusyIndicator() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}

	private static const TEXT_FORMAT:TextFormat = new TextFormat(FontName.MONO_MX, 18, 0x999999);
	private static const ALPHABET:String = "01";//abcdefghijklmnoprqstuvwxyz
	private static const BYTE_NUM:uint = 8;
	private var tf:TextField;

	//--------------------------------------
	//  started
	//--------------------------------------
	private var _started:Boolean = false;
	[Bindable("startedChanged")]
	public function get started():Boolean {return _started;}
	public function set started(value:Boolean):void {
		if (_started != value) {
			_started = value;
			if(started) updateCipher();
			dispatchEvent(new Event("startedChanged"));
		}
	}

	override protected function createChildren():void {
		super.createChildren();
		tf = TextFieldFactory.create(TEXT_FORMAT);
		addChild(tf);
	}

	override protected function measure():void {
		super.measure();
		tf.text = getRandomText();
		measuredWidth = tf.textWidth + 5;
		measuredHeight = tf.textHeight + 5;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		tf.width = w;
		tf.height = h;
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0);
		g.drawRect(0, 0, w, h);
		g.endFill();
	}

	private function addedToStage(event:Event):void {
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		if (started) updateCipher();
	}

	private function removedFromStage(event:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}

	private function updateCipher():void {
		if (started && stage) {
			tf.text = getRandomText();
			invalidateOf(updateCipher);
		}
	}

	private static function getRandomText():String {
		var text:String = "";
		var symbols:int = BYTE_NUM * 8;
		for (var i:int = 0; i < symbols; i++) {
			text += ALPHABET.charAt(Math.round(Math.random() * (ALPHABET.length - 1)));
			if ((i + 1) % 8 == 0 && i != symbols - 1) text += "  ";
		}
		return text;
	}
}
}
