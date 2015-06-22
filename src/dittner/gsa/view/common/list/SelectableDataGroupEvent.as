package dittner.gsa.view.common.list {
import flash.events.Event;

public class SelectableDataGroupEvent extends Event {

	public static const SELECTED:String = "selected";
	public static const DOUBLE_CLICKED:String = "doubleClicked";

	public function SelectableDataGroupEvent(type:String, data:Object = null, bubbles:Boolean = true, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_data = data;
	}

	private var _data:Object;
	public function get data():Object {
		return _data;
	}

	override public function clone():Event {
		return new SelectableDataGroupEvent(type, data, bubbles, cancelable);
	}
}
}
