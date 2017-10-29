package de.dittner.siegmar.model {
import flash.display.Stage;
import flash.filesystem.File;
import flash.system.Capabilities;

public class Device {

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

	private static var _stage:Stage;
	public static function get stage():Stage {
		return _stage;
	}

	public static function init(stage:Stage):void {
		_stage = stage;
		_factor = 1;
	}

	private static var _factor:Number;
	public static function get factor():Number {
		return _factor;
	}


	public static function get dbAlbumFolderPath():String {
		return APP_NAME + File.separator + "Albums";
	}

	public static function get isWIN():Boolean {
		return Capabilities.os.toLowerCase().indexOf("windows") >= 0
	}

	public static function get isMAC():Boolean {
		return Capabilities.os.toLowerCase().indexOf("mac") >= 0
	}

	public static function get isDesktop():Boolean {
		return isWIN || isMAC;
	}

}
}
