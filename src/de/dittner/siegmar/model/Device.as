package de.dittner.siegmar.model {
import flash.display.Stage;
import flash.filesystem.File;
import flash.system.Capabilities;

public class Device {

	public static const APP_NAME:String = "TestMyself";
	public static const TEMP_APP_NAME:String = "TestMyself_temp";
	public static const DB_NAME:String = "vocabularies.db";

	public static const MAX_TEXT_LENGTH:uint = 5000;
	public static const MAX_THEME_NAME_LENGTH:uint = 100;
	public static const MAX_WORD_LENGTH:uint = 100;

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

	public static function get dbRootPath():String {
		return APP_NAME + File.separator;
	}

	public static function get dbPath():String {
		return APP_NAME + File.separator + DB_NAME;
	}

	public static function get dbTempPath():String {
		return TEMP_APP_NAME + File.separator;
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
