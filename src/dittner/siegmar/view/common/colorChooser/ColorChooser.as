package dittner.siegmar.view.common.colorChooser {
import dittner.siegmar.view.common.utils.FontName;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFormat;

import mx.core.UIComponent;
import mx.events.FlexEvent;

import spark.components.supportClasses.StyleableTextField;

[Event(name="colorSelected", type="dittner.siegmar.view.common.colorChooser.SelectColorEvent")]
public class ColorChooser extends UIComponent {
	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 14, 0xffFFff);
	private static const PICKER_SIZE:uint = 20;
	private static const GAP:uint = 10;

	public function ColorChooser() {
		super();
	}

	[Embed(source="/assets/spectrum.png")]
	public static const Spectrum:Class;
	private var spectrum:Bitmap;
	private var tf:StyleableTextField;

	//--------------------------------------
	//  selectedColor
	//--------------------------------------
	private var _selectedColor:uint = 0;
	[Bindable("selectedColorChanged")]
	public function get selectedColor():uint {return _selectedColor;}
	public function set selectedColor(value:uint):void {
		if (_selectedColor != value) {
			_selectedColor = value;
			dispatchEvent(new Event("selectedColorChanged"));
		}
	}

	override protected function createChildren():void {
		super.childrenCreated();
		tf = new StyleableTextField();
		tf.defaultTextFormat = FORMAT;
		tf.multiline = false;
		tf.wordWrap = false;
		tf.embedFonts = true;
		tf.maxChars = 6;
		tf.restrict = "0123456789abcdef";
		tf.editable = true;
		tf.width = 50;
		tf.height = 20;
		tf.addEventListener(FlexEvent.ENTER, enterPressed);
		addChild(tf);

		spectrum = new Spectrum();
		addChild(spectrum);

		addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		addEventListener(MouseEvent.MOUSE_OUT, onOut);
		addEventListener(MouseEvent.CLICK, onClick);
	}

	override protected function measure():void {
		super.measure();
		measuredWidth = spectrum.width;
		measuredHeight = spectrum.height + PICKER_SIZE + GAP;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		redraw(selectedColor);
		spectrum.y = PICKER_SIZE + GAP;
		tf.x = PICKER_SIZE + GAP;
		tf.y = PICKER_SIZE - tf.textHeight >> 1;
	}

	private function enterPressed(e:FlexEvent):void {
		selectedColor = uint("0x" + tf.text);
		dispatchEvent(new SelectColorEvent(SelectColorEvent.COLOR_SELECTED, selectedColor));
		redraw(selectedColor);
	}

	private function onMove(e:MouseEvent):void {
		if (e.localY < spectrum.y) return;
		var color:uint = spectrum.bitmapData.getPixel(e.localX - spectrum.x, e.localY - spectrum.y);
		redraw(color);
	}

	private function onOut(e:MouseEvent):void {
		redraw(selectedColor);
	}

	private function onClick(e:MouseEvent):void {
		if (e.localY < spectrum.y) return;
		selectedColor = spectrum.bitmapData.getPixel(e.localX - spectrum.x, e.localY - spectrum.y);
		redraw(selectedColor);
		dispatchEvent(new SelectColorEvent(SelectColorEvent.COLOR_SELECTED, selectedColor));
	}

	private function redraw(color:uint):void {
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, 0xffFFff);
		g.beginFill(color);
		g.drawRect(0, 0, PICKER_SIZE, PICKER_SIZE);
		g.endFill();
		tf.text = color.toString(16);
	}
}
}