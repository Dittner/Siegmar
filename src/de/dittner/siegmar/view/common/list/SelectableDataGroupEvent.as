package de.dittner.siegmar.view.common.list {
import flash.events.Event;

public class SelectableDataGroupEvent extends Event {

	public static const ITEM_SELECTED:String = "selectedItemChange";
	public static const ITEM_DOUBLE_CLICKED:String = "itemDoubleClicked";
	public static const ITEM_REMOVED:String = "itemRemoved";

	public function SelectableDataGroupEvent(type:String, data:* = null, index:int = -1, bubbles:Boolean = true, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_data = data;
		_index = index;
	}

	private var _data:*;
	public function get data():* {
		return _data;
	}

	private var _index:*;
	public function get index():* {
		return _index;
	}

	override public function clone():Event {
		return new SelectableDataGroupEvent(type, data, index, bubbles, cancelable);
	}
}
}
