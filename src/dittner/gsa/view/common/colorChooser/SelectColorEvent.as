package dittner.gsa.view.common.colorChooser {
import flash.events.Event;

public class SelectColorEvent extends Event {
	public static const COLOR_SELECTED:String = "colorSelected";

	public function SelectColorEvent(type:String, color:uint = 0, bubbles:Boolean = true, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_color = color;
	}

	private var _color:uint = 0;
	public function get color():uint {return _color;}

	override public function clone():Event {
		return new SelectColorEvent(type, color, bubbles, cancelable);
	}
}
}