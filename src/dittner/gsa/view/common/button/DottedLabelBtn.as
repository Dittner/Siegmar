package dittner.gsa.view.common.button {
import flash.events.Event;
import flash.events.MouseEvent;

public class DottedLabelBtn extends DottedLabel {
	public function DottedLabelBtn() {
		super();
		addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		addEventListener(MouseEvent.MOUSE_UP, outHandler);
		setStyle("textDecoration", "underline");
		buttonMode = true;
	}

	//--------------------------------------
	//  downColor
	//--------------------------------------
	private var _downColor:uint = 0;
	[Bindable("downColorChanged")]
	public function get downColor():uint {return _downColor;}
	public function set downColor(value:uint):void {
		if (_downColor != value) {
			_downColor = value;
			dispatchEvent(new Event("downColorChanged"));
		}
	}

	//--------------------------------------
	//  upColor
	//--------------------------------------
	private var _upColor:uint = 0;
	[Bindable("upColorChanged")]
	public function get upColor():uint {return _upColor;}
	public function set upColor(value:uint):void {
		if (_upColor != value) {
			_upColor = value;
			dispatchEvent(new Event("upColorChanged"));
		}
	}

	private function downHandler(event:MouseEvent):void {
		setStyle("color", downColor);
	}

	private function outHandler(event:MouseEvent):void {
		setStyle("color", upColor);
	}
}
}
