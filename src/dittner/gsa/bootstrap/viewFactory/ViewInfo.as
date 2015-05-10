package dittner.gsa.bootstrap.viewFactory {
import flash.display.BitmapData;

public class ViewInfo {
	public function ViewInfo(id:String, title:String, description:String, icon:BitmapData) {
		_id = id;
		_title = title;
		_description = description;
		_icon = icon;
	}

	private var _id:String;
	public function get id():String {return _id;}

	private var _title:String;
	public function get title():String {return _title;}

	private var _description:String;
	public function get description():String {return _description;}

	private var _icon:BitmapData;
	public function get icon():BitmapData {return _icon;}

}
}
