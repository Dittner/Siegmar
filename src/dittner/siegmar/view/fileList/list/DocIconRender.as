package dittner.siegmar.view.fileList.list {
import dittner.siegmar.view.common.utils.FontName;
import dittner.siegmar.view.common.utils.TextFieldFactory;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import mx.core.UIComponent;

public class DocIconRender extends UIComponent {
	private static const WID:uint = 22;
	private static const HEI:uint = 22;

	public function DocIconRender(color:uint = 0, letter:String = "X") {
		super();
		tf = TextFieldFactory.create(new TextFormat(FontName.MYRIAD_MX, 12, textColor, null, null, null, null, null, TextAlign.CENTER));
		addChild(tf);
		_textColor = color;
		_letter = letter;
	}

	//--------------------------------------
	//  textColor
	//--------------------------------------
	private var _textColor:uint;
	[Bindable("colorChanged")]
	public function get textColor():uint {return _textColor;}
	public function set textColor(value:uint):void {
		if (_textColor != value) {
			_textColor = value;
			dispatchEvent(new Event("textColorChanged"));
			invalidateDisplayList();
		}
	}

	//--------------------------------------
	//  letter
	//--------------------------------------
	private var _letter:String;
	[Bindable("letterChanged")]
	public function get letter():String {return _letter;}
	public function set letter(value:String):void {
		if (_letter != value) {
			_letter = value;
			dispatchEvent(new Event("letterChanged"));
			invalidateDisplayList();
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function measure():void {
		measuredWidth = WID;
		measuredHeight = HEI;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 1);
		g.drawRect(0, 0, WID, HEI);
		g.endFill();

		tf.text = letter;
		tf.textColor = textColor;
		tf.width = 21;
		tf.y = (WID - tf.textHeight >> 1) - 1;
	}

	public function render():BitmapData {
		validateDisplayList();
		var bd:BitmapData = new BitmapData(WID, HEI, true, 0);
		bd.draw(this, null, null, null, null, true);
		return bd;
	}

	private var tf:TextField;

}
}