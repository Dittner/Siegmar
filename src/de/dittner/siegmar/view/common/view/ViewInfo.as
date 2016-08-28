package de.dittner.siegmar.view.common.view {
public class ViewInfo {
	public function ViewInfo(id:String, title:String) {
		_id = id;
		_title = title;
	}

	private var _id:String;
	public function get id():String {return _id;}

	private var _title:String;
	public function get title():String {return _title;}

}
}
