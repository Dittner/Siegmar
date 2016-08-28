package de.dittner.siegmar.utils {
import flash.filesystem.File;

public class AppInfo {

	public static const APP_NAME:String = "Siegmar";
	public static const TEXT_DB_NAME:String = "SiegmarText.db";
	public static const PHOTO_DB_NAME:String = "SiegmarPhoto.db";
	public static const MIN_PWD_LEN:uint = 2;

	public static function get dbRootPath():String {
		return APP_NAME + File.separator;
	}

	public static function get applicationDBPath():String {
		return "dataBase" + File.separator + APP_NAME + File.separator;
	}
}
}
