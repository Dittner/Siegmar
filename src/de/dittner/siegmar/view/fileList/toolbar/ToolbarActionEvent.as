package de.dittner.siegmar.view.fileList.toolbar {
import flash.events.Event;

public class ToolbarActionEvent extends Event {

	public static const ACTION_SELECTED:String = "actionSelected";

	public function ToolbarActionEvent(type:String, toolAction:String) {
		super(type, true, false);
		_toolAction = toolAction;
	}

	private var _toolAction:String = "";
	public function get toolAction():String { return _toolAction; }

	override public function clone():Event {
		return new ToolbarActionEvent(type, toolAction);
	}
}
}