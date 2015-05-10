package dittner.gsa.utils {
import flash.filesystem.File;

public class AppInfo {

	public static const APP_NAME:String = "GSA";
	public static const MIN_PWD_LEN:uint = 2;

	public static function get dbRootPath():String {
		return APP_NAME + File.separator;
	}

	public static function get applicationDBPath():String {
		return "dataBase" + File.separator + APP_NAME + File.separator;
	}
}
}
