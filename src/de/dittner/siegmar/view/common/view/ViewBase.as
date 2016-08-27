package de.dittner.siegmar.view.common.view {
import flash.events.Event;

import spark.components.Group;

public class ViewBase extends Group {
	public function ViewBase() {
		super();
		percentHeight = 100;
		percentWidth = 100;
	}

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String;
	[Bindable("titleChanged")]
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_title != value) {
			_title = value;
			dispatchEvent(new Event("titleChanged"));
		}
	}

}
}
