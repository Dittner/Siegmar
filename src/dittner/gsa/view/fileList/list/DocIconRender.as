package dittner.gsa.view.fileList.list {
import dittner.gsa.view.common.utils.FontName;
import dittner.gsa.view.common.utils.TextFieldFactory;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import mx.core.UIComponent;

public class DocIconRender extends UIComponent {
	private static const RAD:uint = 11;

	public function DocIconRender(color:uint = 0, letter:String = "X") {
		super();
		tf = TextFieldFactory.create(new TextFormat(FontName.ARIAL_MX, 12, textColor, null, null, null, null, null, TextAlign.CENTER));
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
		measuredWidth = 2 * RAD;
		measuredHeight = 2 * RAD;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0, 1);
		g.drawCircle(RAD, RAD, RAD);
		g.endFill();

		tf.text = letter;
		tf.textColor = textColor;
		tf.width = 21;
		tf.y = (2 * RAD - tf.textHeight >> 1) - 1;
	}

	public function render():BitmapData {
		validateDisplayList();
		var bd:BitmapData = new BitmapData(2 * RAD, 2 * RAD, true, 0);
		bd.draw(this, null, null, null, null, true);
		return bd;
	}

	private var tf:TextField;

}
}